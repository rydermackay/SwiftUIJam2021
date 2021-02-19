//
//  Game.swift
//  MatchingGame
//
//  Created by Ryder Mackay on 2021-02-19.
//

import Foundation

class Card: ObservableObject {
    let animal: Character
    
    @Published
    var visible: Bool = false
    
    init(animal: Character) {
        self.animal = animal
    }
}

extension Card: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

class Game {
    
    enum Difficulty {
        case easy, medium, hard
        
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
    
    let difficulty: Difficulty
    
    let cards: [Card]
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        
        let possibleAnimals: [Character] = [
            "🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐦","🐤","🐥","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🪱","🐛","🦋","🐞","🐜","🪰","🪲","🦟","🦗","🕷","🕸","🐢","🐍","🦎","🦖","🦕","🦑","🦐","🦞","🦀","🐡","🐠","🐟","🐬","🐳","🐋","🦈","🦭","🐊","🐅","🐆","🦓","🦍","🦧","🦣","🐘","🦛","🦏","🐪","🐫","🦒","🦘","🦬","🐃","🐂","🐄","🐎","🐖","🐏","🐑","🦙","🐐","🦌","🐕","🐩","🦮","🐕‍🦺","🐈","🐈‍⬛","🐓","🦃","🦤","🦚","🦢","🦩","🕊","🐇","🦝","🦨","🦫","🦦","🦥","🐁","🐀","🐿","🦔","🐉","🐲"
        ]
        
        // add pairs of cards
        var animals: [Character] = []
        while animals.count < difficulty.numberOfCards,
              let animal = possibleAnimals.randomElement(),
              !animals.contains(animal) {
            animals.append(animal)
            animals.append(animal)
        }
        animals.shuffle()
        
        cards = animals.map(Card.init(animal:))
    }
    
}
