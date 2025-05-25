//
//  ContentView.swift
//  Flashzilla
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    
    @Query private var cardsData: [Card]
    
    @State private var cards = [Card]()
    @State private var isActive = true
    @State private var timeRemaining = 100
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) { isCorrect in
                            withAnimation {
                                removeCard(card: card, isWrong: !isCorrect)
                            }
                        }
                        .id(card.id)
                        .stacked(at: cards.firstIndex(where: { $0.id == card.id }) ?? 0, in: cards.count)
                        .allowsHitTesting(cards.last?.id == card.id)
                        .accessibilityHidden(cards.last?.id != card.id)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
                
            }
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                if let card = cards.last {
                                    removeCard(card: card, isWrong: true)
                                }
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                if let card = cards.last {
                                    removeCard(card: card)
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(card: Card, isWrong: Bool = false) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        let removedCard = cards.remove(at: index)

        if isWrong {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                 let newCard = Card(id: UUID(), prompt: removedCard.prompt, answer: removedCard.answer)
                 cards.insert(newCard, at: 0)
            }
        }

        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        cards = cardsData
    }
    
    
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}


#Preview {
    ContentView()
}
