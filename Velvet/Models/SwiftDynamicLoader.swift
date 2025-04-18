//
//  SwiftDynamicLoader.swift
//  Velvet
//
//  Created by Anton Marini on 4/17/25.
//

import Foundation
import Darwin
import Satin

class SwiftDynamicLoader {
    private var handle: UnsafeMutableRawPointer?

    func loadLibrary(at path: String, runtimeLibPath: String? = nil) -> Bool {

        if let libPath = runtimeLibPath {
            setenv("DYLD_LIBRARY_PATH", libPath, 1)
        }

        handle = dlopen(path, RTLD_NOW | RTLD_GLOBAL)
        if handle == nil {
            print("dlopen error: \(String(cString: dlerror()))")
            return false
        }
        return true
    }
    
    func unloadLibrary() {
        if let handle = handle {
            dlclose(handle)
            self.handle = nil
        }
    }
    
    
    func printTypeOrigin(of object: AnyObject) {
        let type: any AnyObject.Type = type(of: object)
        print("🧪 Dynamic type: \(type)")

        let ptr = unsafeBitCast(type, to: UnsafeRawPointer.self)

        var info = Dl_info()
        if dladdr(ptr, &info) != 0 {
            print("🧪 Type loaded from: \(String(cString: info.dli_fname))")
        } else {
            print("❌ Could not resolve symbol location")
        }
    }

    func instantiateRenderer<T: AnyObject>(as type: T.Type, symbolName: String = "createRenderer") -> T? {
        guard let handle = handle else {
            print("No library loaded.")
            return nil
        }

        typealias Constructor = @convention(c) () -> UnsafeMutableRawPointer

        guard let sym = dlsym(handle, symbolName) else {
            print("❌ dlsym error: \(String(cString: dlerror()))")
            return nil
        }

        let constructor = unsafeBitCast(sym, to: Constructor.self)
        let instancePtr = constructor()

        let raw = Unmanaged<AnyObject>.fromOpaque(instancePtr).takeRetainedValue()


        
        printTypeOrigin(of: raw)
        print("🧪 Cast to MetalViewRenderer:", raw is MetalViewRenderer)

        print("🔍 Is T: \(raw is T)")

        if let casted = raw as? T {
            return casted
        } else {
            print("❌ Failed to cast loaded instance to expected type \(T.self)")
            return nil
        }
    }

}
