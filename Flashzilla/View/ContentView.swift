//
//  ContentView.swift
//  Flashzilla
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        CardView(card: .example)
    }
}


#Preview {
    ContentView()
}
