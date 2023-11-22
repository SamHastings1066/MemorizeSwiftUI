//
//  ThemeEditor.swift
//  Memorize
//
//  Created by sam hastings on 20/11/2023.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @State var previousEmojiString = ""
    private var colorBinding: Binding<Color> {
        //Documentation for the initializer used below: https://developer.apple.com/documentation/swiftui/binding/init(get:set:)-6g3d5
           Binding<Color>(
               get: {
                   Color(rgba: theme.color)
               },
               set: {
                   theme.color = Theme.RGBA(color: $0)
               }
           )
       }


    
    var body: some View {
        Form {
            Section(header: Text("Theme name")) {
                TextField(text: $theme.name){Text("Theme name")}
            }
            Section(header: Text("Theme attributes")) {
                ColorPicker("Color", selection: colorBinding)
                Stepper("\(theme.numPairs) pairs", value: $theme.numPairs)
                    .onChange(of: theme.numPairs) { newValue in
                        if newValue < 2 {
                            theme.numPairs = 2
                        } else if newValue > theme.emojisString.count {
                            theme.numPairs = theme.emojisString.count
                        }
                    }
                TextField("Enter emojis", text: $theme.emojisString)
                    .onAppear{
                        previousEmojiString = theme.emojisString
                    }
                    .onChange(of: theme.emojisString) { newValue in
                        if newValue.count < 2 {
                            theme.emojisString = previousEmojiString
                        } else {
                            theme.emojisString = newValue.filter{ $0.isEmoji }
                            previousEmojiString = theme.emojisString
                        }
                    }
                
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        self.unicodeScalars.allSatisfy {$0.properties.isEmoji}
    }
}

// Create custom view to display the emojis in the theme and a button to add emojis which triggers a popover with new emojis as well as a longclick to delete emojis.
//@State private var cardColor: Color
//@State var bgColor: Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
//ColorPicker("Card color", selection: Color(rgba: $theme.color))
//#Preview {
//    ThemeEditor()
//}
