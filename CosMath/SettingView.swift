//
//  SettingView.swift
//  CosMath
//
//  Created by Ruby Kim on 2024-11-08.
//

import SwiftUI

struct SettingView: View {
    @Binding var selectedTable: Int
    @Binding var numOfQuestions: Int
    @Binding var difficulty: String
    
    //local variables
    let tables = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let difficulties = ["Easy", "Medium", "Hard"]
    
    func incrementStep() {
        numOfQuestions += 5
        if numOfQuestions > 21 { numOfQuestions = 20 }
    }
    
    func decrementStep() {
        numOfQuestions -= 5
        if numOfQuestions < 4 { numOfQuestions = 5 }
    }
    
    var body: some View {
            //title
            Text("Customize your game")
                .font(FontStyles.title)
                .foregroundStyle(.white.opacity(0.9))
                .shadow(
                        color: Color.primary.opacity(0.3), /// shadow color
                        radius: 5, /// shadow radius
                        x: 3, /// x offset
                        y: 6 /// y offset
                    )
            
            // ---game settings---
            ZStack {
                //container boxs design
                Rectangle()
                    .fill(Color.black.opacity(0.1)) // Light gray background
                                .cornerRadius(20) // Rounded corners
                                .padding() // Padding around the rectangle
                VStack(alignment: .leading) {
                    Text("Choose Times Table")
                        .font(FontStyles.body)
                        .foregroundStyle(.black.opacity(0.7))
                    Divider()
                        .frame(width: 300, height: 1.5)
                        .overlay(.black.opacity(0.5))
                        .padding(.bottom, 3)
                    Picker("", selection: $selectedTable) {
                        ForEach(tables, id: \.self) {
                            Text("\($0)")
                                .font(FontStyles.body)
                        }
                    }
                    .font(FontStyles.body)
                    .pickerStyle(.segmented)
                }
                .frame(width: 300)
                }
            ZStack {
                //container boxs design
                Rectangle()
                    .fill(Color.black.opacity(0.1)) // Light gray background
                    .cornerRadius(20) // Rounded corners
                    .padding() // Padding around the rectangle
                VStack(alignment: .leading) {
                    //let users decides how many questions to challenge(5 to 20, step: 5)
                    Text("How many questions")
                        .font(FontStyles.body)
                    Divider()
                        .frame(width: 300, height: 1.5)
                        .overlay(.black.opacity(0.5))
                        .padding(.bottom, 3)
                    Stepper("\(numOfQuestions)", onIncrement: {
                        incrementStep()
                    }, onDecrement: {
                        decrementStep()
                    })
                    .font(FontStyles.body)
                    
                }
                .frame(width: 300)
            }
                
            ZStack {
                //container boxs design
                Rectangle()
                        .fill(Color.black.opacity(0.1)) // Light gray background
                        .cornerRadius(20) // Rounded corners
                        .padding() // Padding around the rectangle
                VStack(alignment: .leading) {
                    //let users decides set the difficulties and get the multipliers depends on it(esay: 1~5, medium: 1~10, hard: 1~12. refer the getMultiplier() func)
                    Text("Set Difficulties")
                        .font(FontStyles.body)
                    Divider()
                        .frame(width: 300, height: 1.5)
                        .overlay(.black.opacity(0.5))
                        .padding(.bottom, 3)
                    Picker("", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) {
                            Text("\($0)")
                            .font(FontStyles.body)
                        }
                    }
                    .font(FontStyles.body)
                    .pickerStyle(.segmented)
                    .frame(width: 300)
                }
            }
        }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a parent view for binding in the preview
        SettingView(selectedTable: .constant(2),
                    numOfQuestions: .constant(5),
                    difficulty: .constant("Easy"))
    }
}
