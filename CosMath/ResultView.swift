//
//  ResultView.swift
//  CosMath
//
//  Created by Ruby Kim on 2024-11-08.
//

import SwiftUI

struct ResultView: View {
    @Binding var questionSave: [String]
    @Binding var score: Int
    @Binding var planet: String
    
    private func levelGenerator() -> String {
        switch planet {
        case "WhiteStar":
            return "level 1: Star Baby"
        case "Earth":
            return "level 2: Earth Human"
        case "FullMoon":
            return "level 3: Moon Walker"
        case "Saturn":
            return "level 4: Space Cowboy"
        case "RocketWhite":
            return "level 5: Rocket Emperor"
        case "Sun":
            return "level 6: Sun Demigod"
        default:
            return "level 0: Infinite"
        }
    }
    
    
    var body: some View {
        VStack {
            //title
            Text("Answer Sheets & Result")
                .font(FontStyles.body)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            //scrollview to displaying questions in this game and the correct answer sheets so that user can study them
            ScrollView {
                VStack {
                    ForEach(questionSave, id: \.self) { question in
                        HStack {
                            Text(question)
                                .font(FontStyles.body)
                                .padding()
                            
                            Spacer()
                        }
                    }
                }
                .background(Color.black.opacity(0.2)) // Optional background for each item
                .cornerRadius(12) // Rounded corners
            }
            .padding(.bottom, 30)
            .frame(maxHeight: 300)
            
            VStack(alignment: .center) {
                //showing planets depends on user's score instead of justing displaying number, give motivations and fun to aim the higher score for users
                Text("Your planet is...")
                    .font(FontStyles.title)
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(
                        color: Color.primary.opacity(0.3), /// shadow color
                        radius: 5, /// shadow radius
                        x: 3, /// x offset
                        y: 6 /// y offset
                    )
                HStack {
                    //the planet decides by score
                    Image(planet)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    HStack {
                        //planet captions depends on the result
                        Text(levelGenerator())
                            .font(FontStyles.caption)
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ResultView(questionSave: .constant(["2 x 2 = 4", "3 x 5 = 15", "6 x 7 = 42"]),
               score: .constant(50),
               planet: .constant("FullMoon"))// Provide some mock data for preview
}
