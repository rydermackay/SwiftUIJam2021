//
//  MatchingGameApp.swift
//  Shared
//
//  Created by Ryder Mackay on 2021-02-19.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published
    var cardColor: Color = .accentColor
    
    @AppStorage("vocabulary")
    var vocabulary: Game.Vocabulary = .animals
}

@main
struct MatchingGameApp: App {
    
    @AppStorage("difficulty")
    private var difficulty: Game.Difficulty = .medium
    
    let settings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            let game = Game(difficulty: difficulty, vocabulary: settings.vocabulary)
            GameView(game: game).environmentObject(settings)
        }
        
        #if os(macOS)
        Settings {
            SettingsView().environmentObject(settings)
        }
        #endif
    }
}

struct SettingsView: View {
    @AppStorage("difficulty")
    private var difficulty: Game.Difficulty = .medium
    
//    @AppStorage("cardColor")
    @EnvironmentObject
    private var settings: UserSettings
    
    var body: some View {
        Form {
            Picker(selection: $settings.vocabulary, label: Text("Vocabulary:")) {
                ForEach(Game.Vocabulary.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            Picker(selection: $difficulty, label: Text("Difficulty:")) {
                ForEach(Game.Difficulty.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            ColorPicker("Card Color:", selection: $settings.cardColor)
        }
        .padding(20)
        .frame(width: 350, height: nil, alignment: .center)
    }
    
}
