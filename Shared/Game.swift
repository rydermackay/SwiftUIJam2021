//
//  Game.swift
//  MatchingGame
//
//  Created by Ryder Mackay on 2021-02-19.
//

import Foundation
import SwiftUI

class Card: ObservableObject {
    
    let string: String
    let color: Color?
    
    weak var pair: Card?
    
    @Published
    var visible: Bool = false
    
    init(string: String, color: Color? = nil) {
        self.string = string
        self.color = color
    }
    
    static func matchingPair(_ content: Game.CardContent) -> (Card, Card) {
        let (string, color) = content
        let card1 = Card(string: string, color: color)
        let card2 = Card(string: string, color: color)
        card1.pair = card2
        card2.pair = card1
        return (card1, card2)
    }
}

extension Card: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

class Game: ObservableObject {
    
    typealias CardContent = (string: String, color: Color?)
    
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        
        var id: String { return rawValue }
        
        var numberOfCards: Int {
            switch self {
            case .easy:
                return 8
            case .medium:
                return 18
            case .hard:
                return 36
            }
        }
    }
    
    enum Vocabulary: String, CaseIterable, Identifiable {
        case animals = "animals"
        case letters = "letters"
        case numbers = "numbers"
        case symbols = "symbols"
        
        var id: String { return rawValue }
        
        var candidates: [CardContent] {
            switch self {
            case .animals:
                return animals
            case .letters:
                return letters
            case .numbers:
                return numbers
            case .symbols:
                return symbols
            }
        }
        
        private var animals: [CardContent] {
            return [
                "🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐦","🐤","🐥","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🪱","🐛","🦋","🐞","🐜","🪰","🪲","🦟","🦗","🕷","🕸","🐢","🐍","🦎","🦖","🦕","🦑","🦐","🦞","🦀","🐡","🐠","🐟","🐬","🐳","🐋","🦈","🦭","🐊","🐅","🐆","🦓","🦍","🦧","🦣","🐘","🦛","🦏","🐪","🐫","🦒","🦘","🦬","🐃","🐂","🐄","🐎","🐖","🐏","🐑","🦙","🐐","🦌","🐕","🐩","🦮","🐕‍🦺","🐈","🐈‍⬛","🐓","🦃","🦤","🦚","🦢","🦩","🕊","🐇","🦝","🦨","🦫","🦦","🦥","🐁","🐀","🐿","🦔","🐉","🐲"
            ].map { ($0, nil) }
        }
        
        private var letters: [CardContent] {
            // can't enumerate a CharacterSet? apparently there's no "reasonable" way
            // https://stackoverflow.com/questions/43322441/is-there-any-reasonable-way-to-access-the-contents-of-a-characterset
            
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { (String($0), .randomHue) }
        }
        
        private var numbers: [CardContent] {
            return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"].map { ($0, .randomHue) }
        }
        
        private var symbols: [CardContent] {
            return "􀙬􀠒􀋦􀓏􀓑􀌛􀯕􀥳􀆮􀆺􀇃􀇤􀇥".map { (String($0), .randomHue )}
        }
    }
    
    let difficulty: Difficulty
    
    let cards: [Card]
    
    init(difficulty: Difficulty, vocabulary: Vocabulary) {
        self.difficulty = difficulty
        
        let candidates = vocabulary.candidates
        
        // add pairs of cards
        var cards: [Card] = []
        while cards.count < difficulty.numberOfCards,
              let content = candidates.randomElement() {
            guard !cards.contains(where: { $0.string == content.string }) else {
                continue
            }
            let (card1, card2) = Card.matchingPair(content)
            cards.append(card1)
            cards.append(card2)
        }
        self.cards = cards.shuffled()
    }
    
    enum State {
        case started
        case findMatch(for: Card)
        case animatingMismatch
        case won
    }
    
    func pick(_ card: Card) {
        precondition(cards.contains { $0 === card })
        guard !matchedPairs.contains(where: { (card1, card2) in card1 === card || card2 === card }) else {
            print("selected already matched card, ignoring")
            return
        }
        
        switch state {
        case .started:
            card.visible = true
            state = .findMatch(for: card)
        case .findMatch(for: let pair):
            card.visible = true
            if card.pair === pair {
                // hooray
                matchedPairs.append((card, pair))
                state = .started
                
                if matchedPairs.count == cards.count / 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.state = .won // woohoo
                    }
                }
            } else {
                // boo
                mismatchCount += 1
                state = .animatingMismatch
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    card.visible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        pair.visible = false
                        self.state = .started
                    }
                }
            }
        case .animatingMismatch:
            break
        case .won:
            break // can't do anything
        }
    }
    
    // keep these visible
    @Published
    var matchedPairs: [(Card, Card)] = []
    
    @Published
    var state: State = .started
    
    @Published
    var mismatchCount: Int = 0
    
}

private extension Color {
    static var randomHue: Color {
        Color(hue: .random(in: 0...1), saturation: 0.7, brightness: 0.9)
    }
}
