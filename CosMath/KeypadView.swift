//
//  KeypadView.swift
//  CosMath
//
//  Created by Ruby Kim on 2024-12-07.
//

import SwiftUI


//custom user input keypad button(each)
struct KeypadButton: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .font(FontStyles.body)
                .frame(width: 80, height: 60)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(3)
        }
    }
}

//custom user input keypad(whole)
struct KeypadView: View {
    @Binding var inputValue: String
    @State private var counter = 0
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1..<10) { number in
                KeypadButton(label: "\(number)") {
                    inputValue.append("\(number)")
                    counter += 1
                }
                .sensoryFeedback(.increase, trigger: counter)
            }
            
            // Empty button to maintain the keypad layout
            KeypadButton(label: "") {}
            
            KeypadButton(label: "0") {
                inputValue.append("0")
            }
            
            KeypadButton(label: "⌫") {
                if !inputValue.isEmpty {
                    inputValue.removeLast()
                }
            }
        }
    }
}
