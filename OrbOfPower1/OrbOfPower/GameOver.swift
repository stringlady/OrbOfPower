//
//  GameOver.swift
//  OrbOfPower
//
//  Created by Anaya Bussey on 8/1/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import SpriteKit



class GameOver: SKScene {
    
    // UI Connections
    var buttonRestart: MSButtonNode!
    
    
    
    override func didMove(to view: SKView) {
        //Set UI Connections
        buttonRestart = self.childNode(withName: "//buttonRestart") as! MSButtonNode
        
        /* Reset the game when the reset button is tapped */
        buttonRestart.selectedHandler = { [unowned self] in
            self.loadGame()
        }
    }
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene(fileNamed:"GameScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        /* 4) Start game scene */
        skView.presentScene(scene)
    }
    
}
