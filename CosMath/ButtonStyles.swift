//
//  ButtonStyles.swift
//  CosMath
//
//  Created by Ruby Kim on 2024-12-07.
//

import Foundation
import SwiftUI

//silver button(start, restart)
struct SilverButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(minWidth: 180, minHeight: 60)
                .background(LinearGradient(colors: [.gray, .white, .gray], startPoint: .top, endPoint: .bottom))
                .foregroundStyle(.black.opacity(0.5))
                .cornerRadius(10)
                .font((.custom("Futura", fixedSize: 30))
                      )
                .shadow(
                        color: Color.primary.opacity(0.3), /// shadow color
                        radius: 2, /// shadow radius
                        x: 3, /// x offset
                        y: 6 /// y offset
                    )
                .scaleEffect(configuration.isPressed ? 2.0 : 1)
                .animation(.easeOut(duration: 0.8), value: configuration.isPressed)
        }
}


//black button(answer submit)
struct BlackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(minWidth: 250, minHeight: 60)
                .background(LinearGradient(colors: [.black, .gray, .black], startPoint: .top, endPoint: .bottom))
                .foregroundStyle(.white.opacity(0.8))
                .cornerRadius(10)
                .font((.custom("Futura", fixedSize: 30))
                )
                .shadow(
                        color: Color.primary.opacity(0.3), /// shadow color
                        radius: 2, /// shadow radius
                        x: 3, /// x offset
                        y: 6 /// y offset
                    )
                .scaleEffect(configuration.isPressed ? 1.5 : 1)
                .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
        }
}
