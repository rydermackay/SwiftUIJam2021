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
    
    @Published
    var visible: Bool = false
    
    init(string: String, color: Color? = nil) {
        self.string = string
        self.color = color
    }
}

extension Card: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

class Game {
    
    typealias CardContent = (string: String, color: Color?)
    
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        
        var id: String { return rawValue }
        
        var numberOfCards: Int {
            switch self {
            case .easy:
                return 12
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
        var cardFaces: [CardContent] = []
        while cardFaces.count < difficulty.numberOfCards,
              let content = candidates.randomElement() {
            guard !cardFaces.contains(where: { $0.string == content.string }) else {
                continue
            }
            cardFaces.append(content)
            cardFaces.append(content)
        }
        cardFaces.shuffle()
        
        cards = cardFaces.map(Card.init)
    }
    
}

private extension Color {
    static var randomHue: Color {
        Color(hue: .random(in: 0...1), saturation: 0.7, brightness: 0.9)
    }
}
