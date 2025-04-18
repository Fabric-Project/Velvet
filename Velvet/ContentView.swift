//
//  ContentView.swift
//  Velvet
//
//  Created by Anton Marini on 4/16/25.
//

import SwiftUI
import Satin
import CodeEditorView

struct ContentView: View {
    
    let theme = Theme(colourScheme: .dark,
                            fontName: "SFMono-Medium",
                            fontSize: 13.0,
                            textColour: OSColor(red: 0.87, green: 0.87, blue: 0.88, alpha: 1.0),
                            commentColour: OSColor(red: 0.51, green: 0.55, blue: 0.59, alpha: 1.0),
                            stringColour: OSColor(red: 0.94, green: 0.53, blue: 0.46, alpha: 1.0),
                            characterColour: OSColor(red: 0.84, green: 0.79, blue: 0.53, alpha: 1.0),
                            numberColour: OSColor(red: 0.81, green: 0.74, blue: 0.40, alpha: 1.0),
                            identifierColour: OSColor(red: 0.41, green: 0.72, blue: 0.64, alpha: 1.0),
                            operatorColour: OSColor(red: 0.62, green: 0.94, blue: 0.87, alpha: 1.0),
                            keywordColour: OSColor(red: 0.94, green: 0.51, blue: 0.69, alpha: 1.0),
                            symbolColour: OSColor(red: 0.72, green: 0.72, blue: 0.73, alpha: 1.0),
                            typeColour: OSColor(red: 0.36, green: 0.85, blue: 1.0, alpha: 1.0),
                            fieldColour: OSColor(red: 0.63, green: 0.40, blue: 0.90, alpha: 1.0),
                            caseColour: OSColor(red: 0.82, green: 0.66, blue: 1.0, alpha: 1.0),
                            backgroundColour: OSColor(red: 0.16, green: 0.16, blue: 0.18, alpha: 0.6),
                            currentLineColour: OSColor(red: 0.19, green: 0.20, blue: 0.22, alpha: 0.6),
                            selectionColour: OSColor(red: 0.40, green: 0.44, blue: 0.51, alpha: 1.0),
                            cursorColour: OSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                            invisiblesColour: OSColor(red: 0.33, green: 0.37, blue: 0.42, alpha: 1.0)
                      )
    @State var redraw: Bool = false
    
    let sourceCode = SourceCodeModel(fileUrl: URL(fileURLWithPath: "/Users/vade/Documents/Repositories/Fabric/Velvet/Velvet/Renderer3D.swift"))
    
    var body: some View {
        ZStack {
            
            if let renderer = self.sourceCode.rendererBox
            {
                AnyView(SatinMetalView(renderer:renderer))
                    .id(ObjectIdentifier(renderer))

            }
            else
            {
                [Color.red, Color.blue, Color.green].randomElement() ?? Color.yellow
            }

            HSplitView
            {
                Spacer()
                CodeEditor(text: Binding(get: { self.sourceCode.content },
                                         set: { self.sourceCode.content = $0
                } ),
                           position: .constant(CodeEditor.Position.init()),
                           messages: .constant([]),
                           language: .swift()
                )
                .scrollContentBackground(.hidden)
                .environment(\.codeEditorTheme, self.theme)
                .onChange(of: self.sourceCode.rendererDidChange) { _, _ in
                    self.redraw.toggle()
                }
            }
            
        }
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)

    }
}

#Preview {
    ContentView()
}
