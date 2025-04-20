//
//  DynamicLoader.swift
//  Velvet
//
//  Created by Anton Marini on 4/16/25.
//

import Foundation
import Darwin

class SwiftDynamicCompiler {
    var stdout: String = ""
    var stderr: String = ""

    /// Compiles the given Swift source string into a dynamic library.
    func compile(
        sourceURL:URL,
        moduleSearchPaths: [String],
        libSearchPaths: [String],
        linkLibraries: [String],
        headerSearchPaths: [String] = [],
        moduleMapPath: String? = nil,
        frameworkSearchPaths: [String] = [],
        linkFrameworks: [String] = []
    ) -> URL? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let outputName = sourceURL.deletingPathExtension().lastPathComponent
        let dylibPath = tempDir.appendingPathComponent("lib\(outputName).dylib").path

        if fileManager.fileExists(atPath: dylibPath)
        {
            try? fileManager.removeItem(atPath: dylibPath)
        }

        var args = [
//            "-v",
            sourceURL.path,
            "-emit-library",
            "-o", dylibPath,
            "-enable-library-evolution",
            "-DSWIFT_PACKAGE",
            "-target", "arm64-apple-macos14.0"
        ]

        for path in moduleSearchPaths {
            args.append(contentsOf: ["-I", path])
        }

        for path in libSearchPaths {
            args.append(contentsOf: ["-L", path])
        }

        for lib in linkLibraries {
            args.append("-l\(lib)")
        }

        for path in frameworkSearchPaths {
            args.append(contentsOf: ["-F", path])
        }

        for framework in linkFrameworks {
            args.append(contentsOf: ["-framework", framework])
        }

        for path in headerSearchPaths {
            args.append(contentsOf: ["-Xcc", "-I\(path)"])
        }

        if let moduleMap = moduleMapPath {
            args.append(contentsOf: ["-Xcc", "-fmodule-map-file=\(moduleMap)"])
        }

        if let rpath = (libSearchPaths + frameworkSearchPaths).first {
            args.append(contentsOf: ["-Xlinker", "-rpath", "-Xlinker", rpath])
        }
        
        print("/usr/bin/swiftc \(args.joined(separator: " "))")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
        process.arguments = args

        let outPipe = Pipe()
        let errPipe = Pipe()
        process.standardOutput = outPipe
        process.standardError = errPipe

        do {
            try process.run()
            process.waitUntilExit()

            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()

            stdout = String(data: outData, encoding: .utf8) ?? ""
            stderr = String(data: errData, encoding: .utf8) ?? ""

            print(stdout)
            print(stderr)
            if process.terminationStatus == 0
            {
                // Patch linked dylibs to use @rpath instead of relative paths
                let patcher = Process()
                patcher.executableURL = URL(fileURLWithPath: "/usr/bin/install_name_tool")
                patcher.arguments = [
                    "-change", "build/libSatin.dylib", "@rpath/libSatin.dylib",
                    "-change", "build/libSatinCore.dylib", "@rpath/libSatinCore.dylib",
                    dylibPath
                ]
                try? patcher.run()
                patcher.waitUntilExit()
                
                if patcher.terminationStatus == 0
                {
                    return URL(filePath: dylibPath) //nilprocess.terminationStatus == 0
                }
                
                return nil
            }
            else
            {
                return nil
            }
            
        } catch {
            stderr = "Compilation failed to run: \(error)"
            return nil
        }
    }

    func getLastStdout() -> String { stdout }
    func getLastStderr() -> String { stderr }
    
}

class SwiftDynamicCompilerOld
{
    var stdout: String = ""
    var stderr: String = ""

    /// Compiles the given Swift source string into a dynamic library.
    func compile(sourceURL:URL,
                 moduleSearchPaths: [String], libSearchPaths: [String], linkLibraries: [String]) -> Bool
    {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let outputName = sourceURL.deletingPathExtension().lastPathComponent
        let dylibPath = tempDir.appendingPathComponent("lib\(outputName).dylib").path

        var args = [
            sourceURL.path,
            "-emit-library",
            "-o", dylibPath
        ]

        for path in moduleSearchPaths {
            args.append(contentsOf: ["-I", path])
        }

        for path in libSearchPaths {
            args.append(contentsOf: ["-F", path])
        }

        for lib in linkLibraries {
            args.append(contentsOf: ["-framework", "\(lib)"])
        }

//        args.append(contentsOf: ["-Xlinker", "-rpath", "-Xlinker", libSearchPaths.first ?? "."])
        args.append(contentsOf: ["-Xlinker", "-rpath", libSearchPaths.first ?? "."])

        print("Calling swiftc with args: \(args)")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
        process.arguments = args

        let outPipe = Pipe()
        let errPipe = Pipe()
        process.standardOutput = outPipe
        process.standardError = errPipe

        do {
            try process.run()
            process.waitUntilExit()

            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()

            stdout = String(data: outData, encoding: .utf8) ?? ""
            stderr = String(data: errData, encoding: .utf8) ?? ""

            return process.terminationStatus == 0
        } catch {
            stderr = "Compilation failed to run: \(error)"
            return false
        }
    }

    func getLastStdout() -> String { stdout }
    func getLastStderr() -> String { stderr }
}

