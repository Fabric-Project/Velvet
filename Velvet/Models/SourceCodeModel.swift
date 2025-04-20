//
//  SourceCodeModel.swift
//  Velvet
//
//  Created by Anton Marini on 4/16/25.
//
import SwiftUI
import CodeEditorView
import LanguageSupport
import Satin

//public final class MetalViewRendererBox: MetalViewRenderer {
//    private let wrapped: Satin.MetalViewRendererDelegate
//
//    public init(_ wrapped: Satin.MetalViewRendererDelegate) {
//        self.wrapped = wrapped
//        super.init()
//#if DEBUG_VIEWS
//        print("🔧 MetalViewRendererBox initialized with id: \(wrapped.id)")
//#endif
//    }
//
//    override public var id: String {
//        wrapped.id
//    }
//
//    override public func setup() {
//        wrapped.setup()
//    }
//
//    override public func draw(renderPassDescriptor: MTLRenderPassDescriptor, commandBuffer: MTLCommandBuffer) {
//        wrapped.draw(renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer)
//    }
//
//    override public func cleanup() {
//        wrapped.cleanup()
//    }
//}


@Observable class SourceCodeModel : Equatable
{
    static func == (lhs: SourceCodeModel, rhs: SourceCodeModel) -> Bool {
        return lhs.fileURL == rhs.fileURL && lhs.content == rhs.content
    }
    
    private let compiler = SwiftDynamicCompiler()
    private let loader = SwiftDynamicLoader()

    var content: String { didSet { try? save() } }
    let fileURL: URL

    var messages: Set<TextLocated<Message>> = Set()

    var rendererDidChange:Bool = false
    
    // THIS HAS TO BE IGNORED otherwise something with dynamic types fucked up the macro SwiftUI makes
    // Thanks ChatGPT lol
    var renderer:(any MetalViewRendererDelegate)? = nil
    
    init(fileUrl:URL)
    {
        self.fileURL = fileUrl
        self.content = (try? String(contentsOf: self.fileURL, encoding: .utf8) ) ?? ""
    }

    func save() throws
    {
        try self.content.write(to: self.fileURL, atomically: true, encoding: .utf8)
        
    
        
//        let libPath = "/Users/vade/Documents/Repositories/Fabric/Satin/build"
        let libPath = Bundle.main.sharedFrameworksPath!
        let headerSearchPaths = libPath + "/include"
        let swiftModulePath = libPath
        let moduleMapPath = libPath + "/module.modulemap"
        
        let dylibURL = self.compiler.compile(sourceURL: self.fileURL,
                                             moduleSearchPaths: [swiftModulePath], // Only for Satin.swiftmodule
                                             libSearchPaths: [libPath],
                                             linkLibraries: ["Satin", "SatinCore"],
                                             headerSearchPaths: [headerSearchPaths],
                                             moduleMapPath: moduleMapPath,
                                             linkFrameworks: ["Metal", "MetalKit"]
        )
        guard let dylibURL = dylibURL else
        {
            print("Error Compiling", compiler.getLastStderr())
//            self.parseErrorString(errorMsg: compiler.getLastStderr() )
            
            return
        }
        
        print("\nSuccessfully compiled: \(dylibURL)\n")
        
        self.renderer?.cleanup()
        self.renderer = nil
        self.rendererDidChange.toggle()

        self.loader.unloadLibrary()
        
        
        print("\nTrying to load: \(dylibURL) ")//- DYLD_LOOKUP \(libPath)\n ")

        if self.loader.loadLibrary(at: dylibURL.path(), runtimeLibPath: nil)
        {
            let renderer = loader.instantiateRenderer(as: MetalViewRenderer.self)
            if let renderer = renderer {
                print("✅ cast to MetalViewRenderer succeeded")
            
                // Test some dumb shit
                print(Unmanaged.passUnretained(renderer).toOpaque())
                print(Unmanaged.passRetained(renderer).autorelease().toOpaque())

                print("Source Code instantiateRenderer id: \(renderer.id)")

                // When ready:
                DispatchQueue.main.async {
                    self.renderer = renderer
                    self.rendererDidChange.toggle()
                }

//                DispatchQueue.main.async {
//                    let window = NSApplication.shared.windows.first
//                    let vc = MetalViewController(renderer: renderer)
//                    window?.contentViewController = vc
//                }

            
                
            } else {
                print("❌ cast to MetalViewRenderer failed!")
            }
        }
        
        //        NSWorkspace.shared.open(dylibURL.deletingLastPathComponent())
    }
    
    private func parseErrorString(errorMsg:String)
    {
//        for errorLine in errorMsg.components(separatedBy: .newlines)
//        {
            self.parseShaderLog(errorMsg)
//        }
//        let message = Message(category: .error, length: 4, summary: errorMsg,
//                              description: NSAttributedString(string:errorMsg) )
//
//        let textLocated:TextLocated<Message> = TextLocated<Message>(location: TextLocation(zeroBasedLine: 0, column: 0), entity: message)
//
//        self.messages = Set(arrayLiteral: textLocated)
    }
    
    private func parseShaderLog(_ log: String)
    {
//        let pattern = #"program_source:(\d+):(\d+): (error|note): (.+)"#
//        var messages: [ShaderMessage] = []
        let pattern = #"program_source:(\d+):(\d+): (error|note): (.+)\n([^\n]*)\n?([^\n]*)?"#

        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: log, options: [], range: NSRange(log.startIndex..., in: log))
        
        for match in matches
        {
            if  let lineRange = Range(match.range(at: 1), in: log),
                let columnRange = Range(match.range(at: 2), in: log),
                let typeRange = Range(match.range(at: 3), in: log),
                let messageRange = Range(match.range(at: 4), in: log) {
                
                // Capture additional context lines (if available)
                let contextLine = match.range(at: 5).location != NSNotFound ? String(log[Range(match.range(at: 5), in: log)!]) : nil
//                let hintLine = match.range(at: 6).location != NSNotFound ? String(log[Range(match.range(at: 6), in: log)!]) : nil

                let line = Int(log[lineRange]) ?? 0
                let column = Int(log[columnRange]) ?? 0
                let category:Message.Category =  ( String(log[typeRange]) == "note" ) ? .informational : .error
                let summary = String(log[messageRange])
//                let summaryAndContext = [ String(log[messageRange]), contextLine ?? ""].joined(separator: "\n")
                
                let message = Message(category: category,
                                      length: contextLine?.count ?? 0,
                                      summary:summary,
                                      description: AttributedString(contextLine ?? "") )
                
                let textLocated:TextLocated<Message> = TextLocated<Message>(location: TextLocation(zeroBasedLine: line, column: column), entity: message)
                
                if let textLocated = self.remapShaderErrors(toOriginalSource:textLocated, sourceString: self.content, sourceSubString:contextLine ?? "")
                {
                    self.messages.insert( textLocated)
                }
            }
        }
    }
    
    func remapShaderErrors(toOriginalSource message: TextLocated<Message>, sourceString: String, sourceSubString:String) -> TextLocated<Message>?
    {
        let sourceLines = sourceString.components(separatedBy: "\n")
        
        //        let compiledLine = message.location.zeroBasedLine
        let compiledColumn = message.location.zeroBasedColumn
//        let messageSummary = message.entity.summary
        
        // Find the closest matching line in sourceString
        var bestMatchIndex: Int? = nil
        
        for (index, line) in sourceLines.enumerated()
        {
            // If it's an exact match, take it
            if line.contains(sourceSubString)
            {
                bestMatchIndex = index
                break
            }
        }
        
        if let correctedLine = bestMatchIndex
        {
            let correctedLocation = TextLocation(zeroBasedLine: correctedLine, column: compiledColumn)
            let correctedMessage = TextLocated(location: correctedLocation, entity: message.entity)
            
            return correctedMessage
        }
        
        return nil
    }
}
