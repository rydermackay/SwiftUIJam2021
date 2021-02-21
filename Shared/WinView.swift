//
//  WinView.swift
//  MatchingGame
//
//  Created by Ryder Mackay on 2021-02-21.
//

import SwiftUI
import SpriteKit

struct WinView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let sparks = SKEmitterNode(fileNamed: "Sparks")!
        sparks.position.y = 200
        let scene = SKScene(fileNamed: "Win")!
        scene.insertChild(sparks, at: 0)
        let sceneView = SKView(frame: .zero)
//        sceneView.allowsTransparency = true // hmm looks kinda multiplied
        sceneView.presentScene(scene)
        return sceneView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
