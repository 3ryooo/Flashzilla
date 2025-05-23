//
//  ContentView.swift
//  Flashzilla
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image(.background)
                        .resizable()
                        .ignoresSafeArea()
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index])
                            .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
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
