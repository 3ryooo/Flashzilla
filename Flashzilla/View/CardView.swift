//
//  CardView.swift
//  Flashzilla
//

import SwiftUI
import SwiftData

struct CardView: View {
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @GestureState private var isDragging = false
    @State private var cards = [Card]()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.modelContext) private var modelContext
    
    let card: Card
    
    var removal: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(isDragging && offset.width != 0 ? (offset.width > 0 ? .green : .red) : Color.clear)
                )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .updating($isDragging) { value, state, transaction in
                    state = true
                }
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?(offset.width > 0)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
    
}

#Preview {
    CardView(card: Card(prompt: "Sample Prompt", answer: "Sample Answer"))
        .modelContainer(for: Card.self)
}
