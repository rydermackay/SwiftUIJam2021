//
//  Game.swift
//  MatchingGame
//
//  Created by Ryder Mackay on 2021-02-19.
//

import Foundation

class Card: ObservableObject {
    let animal: String
    
    @Published
    var visible: Bool = false
    
    init(animal: String) {
        self.animal = animal
    }
}

extension Card: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

class Game {
    
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
        
        var id: String { return rawValue }
        
        var candidates: [String] {
            switch self {
            case .animals:
                return animals
            case .letters:
                return letters
            case .numbers:
                return numbers
            }
        }
        
        private var animals: [String] {
            return [
                "🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐦","🐤","🐥","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🪱","🐛","🦋","🐞","🐜","🪰","🪲","🦟","🦗","🕷","🕸","🐢","🐍","🦎","🦖","🦕","🦑","🦐","🦞","🦀","🐡","🐠","🐟","🐬","🐳","🐋","🦈","🦭","🐊","🐅","🐆","🦓","🦍","🦧","🦣","🐘","🦛","🦏","🐪","🐫","🦒","🦘","🦬","🐃","🐂","🐄","🐎","🐖","🐏","🐑","🦙","🐐","🦌","🐕","🐩","🦮","🐕‍🦺","🐈","🐈‍⬛","🐓","🦃","🦤","🦚","🦢","🦩","🕊","🐇","🦝","🦨","🦫","🦦","🦥","🐁","🐀","🐿","🦔","🐉","🐲"
            ]
        }
        
        private var letters: [String] {
            // can't enumerate a CharacterSet? apparently there's no "reasonable" way
            // https://stackoverflow.com/questions/43322441/is-there-any-reasonable-way-to-access-the-contents-of-a-characterset
            
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
        }
        
        private var numbers: [String] {
            return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        }
    }
    
    let difficulty: Difficulty
    
    let cards: [Card]
    
    init(difficulty: Difficulty, vocabulary: Vocabulary) {
        self.difficulty = difficulty
        
        let candidates: [String] = vocabulary.candidates
        
        // add pairs of cards
        var cardFaces: [String] = []
        while cardFaces.count < difficulty.numberOfCards,
              let animal = candidates.randomElement() {
            guard !cardFaces.contains(animal) else {
                continue
            }
            cardFaces.append(animal)
            cardFaces.append(animal)
        }
        cardFaces.shuffle()
        
        cards = cardFaces.map(Card.init(animal:))
    }
    
}
