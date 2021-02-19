//
//  MatchingGameApp.swift
//  Shared
//
//  Created by Ryder Mackay on 2021-02-19.
//

import SwiftUI

@main
struct MatchingGameApp: App {
    
    let game = Game(difficulty: .medium)
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
