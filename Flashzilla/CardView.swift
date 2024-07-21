//
//  CardView.swift
//  Flashzilla
//
//  Created by Parth Antala on 2024-07-20.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    let card: Card
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    var removal: ((Bool) -> Void)? = nil
    
    @State private var rotate = false
    @State private var rotation = 0.0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor ?
                        .white :
                    .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor ?
                    nil :
                    RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width == 0 ? .clear : offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
                .animation(.easeInOut, value: offset)
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                } else {
                    if !isShowingAnswer {
                        Text(card.prompt)
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                    }
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .rotation3DEffect(rotate ? .degrees(rotation) : .degrees(0), axis: (x: 1, y: 0, z: 0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture (
            DragGesture()
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        withAnimation {
                            removal?(offset.width > 0)
                        }
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
            withAnimation {
                rotate = true
                rotation += 180
            }
            
        }
        .animation(.bouncy, value: offset)
        
    }
}

#Preview {
    CardView(card: .example)
}
