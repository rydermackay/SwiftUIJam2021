//
//  ContentView.swift
//  Shared
//
//  Created by Ryder Mackay on 2021-02-19.
//

import SwiftUI

struct ContentView: View {
    
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        let numberOfColumns = 6
        let numberOfRows = game.cards.count / numberOfColumns
        let spacing: CGFloat = 16
        let cardHeight: CGFloat = 300
        let height = CGFloat(numberOfRows) * cardHeight + CGFloat(numberOfRows + 1) * spacing
        
        let item = GridItem(.fixed(200), spacing: spacing, alignment: .center)
        let columns = Array(repeating: item, count: numberOfColumns)
        
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(game.cards) {
                CardView(card: $0)
            }
        }
        .padding()
        .frame(width: nil, height: height, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(game: Game(difficulty: .medium))
        }
        
        Group {
            CardView(card: Card(animal: "S"))
        }
    }
}

struct CardView: View {
    @ObservedObject
    var card: Card
    
    @State
    var hovering = false
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        Text(String(card.visible ? card.animal : ""))
            .font(.system(size: 128, weight: .bold, design: Font.Design.rounded))
            .foregroundColor(.black)
            .frame(width: 200, height: 300, alignment: .center)
            .background(card.visible ? Color.white : Color.accentColor)
            .border(Color.accentColor, width: 8)
            .cornerRadius(16.0, antialiased: true)
            .onTapGesture { card.visible.toggle() }
            .onHover { hovering = $0 }
            .zIndex(hovering ? 3 : card.visible ? 2 : 1)
            .scaleEffect(hovering ? 1.02 : 1).animation(.easeInOut(duration: 0.1), value: hovering)
            .rotation3DEffect(
                card.visible ? .radians(.pi) : .zero,
                axis: (x: 0.0, y: 1.0, z: 0.0)).animation(.easeInOut, value: card.visible)
        
    }
}
