//
//  MainMenu.swift
//  OrbOfPower
//
//  Created by Anaya Bussey on 7/26/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var buttonPlay: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Set up scene here */
        
        /* Set UI Connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        
        buttonPlay.selectedHandler = { [unowned self] in
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
