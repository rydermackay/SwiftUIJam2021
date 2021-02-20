//
//  Game.swift
//  MatchingGame
//
//  Created by Ryder Mackay on 2021-02-19.
//

import Foundation

class Card: ObservableObject {
    
    let string: String
    let color: CGColor?
    
    @Published
    var visible: Bool = false
    
    init(string: String, color: CGColor? = nil) {
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
    
    typealias CardContent = (string: String, color: CGColor?)
    
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        
        var id: String { return rawValue }
        
        var numberOfCards: Int {
            return "SwiftUIJam?!".count * 2
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
        
        var candidates: [CardContent] {
            return "SwiftUIJam?!".map{(String($0), .randomHue)}
            switch self {
            case .animals:
                return animals
            case .letters:
                return letters
            case .numbers:
                return numbers
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

private extension CGColor {
    
    // h/t https://stackoverflow.com/a/9493060/1034477
    // https://github.com/o-klp/hsl_rgb_converter/blob/master/converter.js
    private static func hslColor(hue: CGFloat, saturation: CGFloat, luminance: CGFloat, alpha a: CGFloat = 1.0) -> CGColor {
        
        // based on algorithm from http://en.wikipedia.org/wiki/HSL_and_HSV#Converting_to_RGB
        
        let chroma = 1 - abs((2 * luminance) - 1) * saturation
        let huePrime = hue * 360 / 60
        let secondComponent = chroma * (1 - abs((huePrime.truncatingRemainder(dividingBy: 2)) - 1))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        switch floor(huePrime) {
        case 0:
            r = chroma
            g = secondComponent
            b = 0
        case 1:
            r = secondComponent
            g = chroma
            b = 0
        case 2:
            r = 0
            g = chroma
            b = secondComponent
        case 3:
            r = 0
            g = secondComponent
            b = chroma
        case 4:
            r = secondComponent
            g = 0
            b = chroma
        case 5:
            r = chroma
            g = 0
            b = secondComponent
        default:
            fatalError()
        }
        
        let luminanceAdjustment = luminance - (chroma / 2)
        r += luminanceAdjustment
        g += luminanceAdjustment
        b += luminanceAdjustment
        
        return CGColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    
    static var randomHue: CGColor {
        .hslColor(hue: .random(in: 0...1), saturation: 0.7, luminance: 0.45)
    }
}
