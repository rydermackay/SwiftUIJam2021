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
        ContentView(game: Game(difficulty: .medium))
        
        Group {
            CardView(card: Card(animal: "S"))
        }
    }
}

struct CardView: View {
//    @ObservedObject
    var card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        Text(String(card.animal))
            .font(.system(size: 128, weight: .bold, design: Font.Design.rounded))
            .foregroundColor(.black)
            .frame(width: 200, height: 300, alignment: .center)
            .background(Color.white)
            .cornerRadius(16.0, antialiased: true)
            .onTapGesture {
                card.visible.toggle()
            }
//            .rotation
    }
}
