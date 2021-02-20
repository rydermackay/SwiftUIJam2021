//
//  ContentView.swift
//  Shared
//
//  Created by Ryder Mackay on 2021-02-19.
//

import SwiftUI

struct GameView: View {
    
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        let numberOfColumns = 6//game.cards.count / 3
        let numberOfRows = game.cards.count / numberOfColumns
        let spacing: CGFloat = 32
        let cardHeight: CGFloat = 300
        let height = CGFloat(numberOfRows) * cardHeight + CGFloat(numberOfRows + 1) * spacing
        
        let item = GridItem(.fixed(200), spacing: spacing, alignment: .center)
        let columns = Array(repeating: item, count: numberOfColumns)
        
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(game.cards) {
                CardView(card: $0)
            }
        }
        .padding(spacing)
        .frame(width: nil, height: height, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let settings = UserSettings()
    
    static var previews: some View {
        Group {
            GameView(game: Game(difficulty: .medium, vocabulary: .animals))
                .previewLayout(.sizeThatFits)
        }.environmentObject(settings)
        
        Group {
            CardView(card: Card(string: "S", color: .black))
            CardView(card: {
                let card = Card(string: "S", color: .black)
                card.visible = true
                return card
            }())
        }.environmentObject(settings)
    }
}

struct CardView: View {
    @EnvironmentObject
    var userSettings: UserSettings
    
    @ObservedObject
    var card: Card
    
    @State
    var hovering = false
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        let cardColor = userSettings.cardColor
        
        let flipDuration: TimeInterval = 0.3
        let secondHalfFlipAnimation = Animation.timingCurve(0, 1, 0, 1, duration: flipDuration / 2).delay(flipDuration / 2)
        
        Text(String(card.string))
            .font(.system(size: 128, weight: .bold, design: .rounded))
            .opacity(card.visible ? 1 : 0).animation(secondHalfFlipAnimation, value: card.visible)
            .foregroundColor(card.color ?? .black)
            .frame(width: 200, height: 300, alignment: .center)
            .background(card.visible ? Color.white : cardColor).animation(secondHalfFlipAnimation, value: card.visible)
            .cornerRadius(16, antialiased: true)
            .onTapGesture { card.visible.toggle() }
            .onHover { hovering = $0 }
            .zIndex(hovering ? 3 : card.visible ? 2 : 1)
            .scaleEffect(hovering ? 1.02 : 1).animation(.easeInOut(duration: 0.1), value: hovering)
            .rotation3DEffect(card.visible ? .zero : .radians(.pi), axis: (x: 0, y: 1, z: 0), anchor: .center, anchorZ: 0, perspective: 0.35).animation(.easeInOut(duration: flipDuration), value: card.visible)
//            .rotation3DEffect(
//                card.visible ? .zero : .radians(.pi),
//                axis: (x: 0.0, y: 1.0, z: 0.0)).animation(.easeInOut, value: card.visible)
        
    }
}
