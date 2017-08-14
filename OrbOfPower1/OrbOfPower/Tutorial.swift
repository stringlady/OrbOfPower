//
//  GameScene.swift
//  OrbOfPower
//
//  Created by Anaya Bussey on 7/24/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import SpriteKit
import AVFoundation

//enum GameSceneState {
//    case active, gameOver
//}

enum PlayerType {
    case water, land
}

class Tutorial: SKScene, SKPhysicsContactDelegate {
    
    let scrollSpeed: CGFloat = 100
    var scrollLayer: SKNode!
    let fixedDelta: CFTimeInterval = 4.0 / 60.0 /* 60 FPS */
    var hero: SKSpriteNode!
    /* Game management */
    var gameState: GameSceneState = .active
    var sinceTouch: CFTimeInterval = 0
    var distanceLabel: SKLabelNode!
    var water: SKSpriteNode!
    var buttonRestart: MSButtonNode!
    var Enemy: SKSpriteNode!
    let jumpUp = SKAction.moveBy(x: 0, y: 50, duration: 0.3)
    let fallBack = SKAction.moveBy(x: 0, y: -50, duration: 0.3)
    var jumpAction = SKAction()
    var timer: CFTimeInterval = 0
    var pointLabel: SKLabelNode!
    var obstacleLayer: SKNode!
    var splash: AVAudioPlayer?
    var landOrb: SKSpriteNode!
    var waterOrb: SKSpriteNode!
    // var shootOrb: SKSpriteNode!
    var landTransform: SKSpriteNode!
    //var waterTransform: SKSpriteNode!
    var currentType: PlayerType = .land
    var playGame: MSButtonNode!
    var end: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        
        /* Set reference to scrollLayer node */
        scrollLayer = self.childNode(withName: "scrollLayer")
        hero = self.childNode(withName: "//hero") as! SKSpriteNode
        distanceLabel = self.childNode(withName: "distanceLabel") as! SKLabelNode
        water = self.childNode(withName: "//water") as! SKSpriteNode
        buttonRestart = self.childNode(withName: "//buttonRestart") as! MSButtonNode
        pointLabel = self.childNode(withName: "pointLabel") as! SKLabelNode
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        landOrb = self.childNode(withName: "landOrb") as! SKSpriteNode
        waterOrb = self.childNode(withName: "waterOrb") as! SKSpriteNode
       // shootOrb = self.childNode(withName: "shootOrb") as! SKSpriteNode
        landTransform = self.childNode(withName: "landTransform") as! SKSpriteNode
        //waterTransform = self.childNode(withName: "waterTransform") as! SKSpriteNode
        playGame = self.childNode(withName: "playGame") as! MSButtonNode
        end = self.childNode(withName: "//end") as! SKSpriteNode
        
        
        
        /* Setup restart button selection handler */
        buttonRestart.selectedHandler = { [unowned self] in
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = Tutorial(fileNamed:"Tutorial") as Tutorial!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
            
        }
        
        /* Setup play button selection handler */
        playGame.selectedHandler = { [unowned self] in
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
            
        }
        
        /* Hide restart button */
        buttonRestart.state = .MSButtonNodeStateHidden
        
        // Hide play Button
        playGame.state = .MSButtonNodeStateHidden
        
        jumpAction = SKAction.sequence([jumpUp, fallBack])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Apply vertical impulse */
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        
        //Apply subtle rotation
        hero.physicsBody?.applyAngularImpulse(1)
        
        //Reset touch timer
        sinceTouch = 0
        
        /* Skip game update if game no longer active */
        if gameState != .active { return }
        
        if hero.action(forKey: "jump") == nil {
            hero.run(jumpAction, withKey:"jump")
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Grab current velocity
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        //Check and cap vertical velocity
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Process world scrolling */
        scrollWorld()
        
        /* Apply falling rotation */
        if sinceTouch > 0.2 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation.clamp(v1: CGFloat(-90).degreesToRadians(), CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        
        /* Update last touch timer */
        sinceTouch += fixedDelta
        
        distanceLabel.text = String(describing: Int(scrollLayer.position.x) / -10)
        
        /* Skip game update if game no longer active */
        if gameState != .active { return }
        
        //addEnemy()
        
        timer += fixedDelta
        
        pointLabel.text = String(Int(timer))
        
    }
    
    func scrollWorld() {
       
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Hero touches anything, game over */
        
        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        /* Did our hero pass through the 'goal'? */
        if (contactA.node?.name == "water" || contactB.node?.name == "water") && currentType == .land {
            self.hero.removeFromParent()
            
            //playSound()
            
            gameState = .gameOver
            
            /* Show restart button */
            buttonRestart.state = .MSButtonNodeStateActive
            
            buttonRestart.alpha = 1
            
            /* We can return now */
            return
        }
        
        if contactA.node?.name == "landOrb" || contactB.node?.name == "landOrb" {
            currentType = .land
            
            if nodeA.name == "landOrb" {
                contactA.node?.removeFromParent()
            }
            
            if nodeB.name == "landOrb" {
                contactB.node?.removeFromParent()
            }
        }
        
        if contactA.node?.name == "waterOrb" || contactB.node?.name == "waterOrb" {
            currentType = .water
            
            if nodeA.name == "waterOrb" {
                contactA.node?.removeFromParent()
            }
            
            if nodeB.name == "waterOrb" {
                contactB.node?.removeFromParent()
            }
            
        }
        
        if (contactA.node?.name == "water" || contactB.node?.name == "water") && currentType == .water {
           // playSound()
        }
        
        if (contactA.categoryBitMask == 4 || contactB.categoryBitMask == 4) && currentType == .water {
            self.hero.removeFromParent()
            
            gameState = .gameOver
            
            /* Show restart button */
            buttonRestart.state = .MSButtonNodeStateActive
            
            buttonRestart.alpha = 1
            
            /* We can return now */
            return
            
        }
        
        if (contactA.node?.name == "end" || contactB.node?.name == "end") {
            gameState = .gameOver
            
            //Show play button
            playGame.state = .MSButtonNodeStateActive
            
            playGame.alpha = 1
            
            //We can return now
            return
        }
        
        /* Ensure only called while game running */
        if gameState != .active { return }
        
        /* Change game state to game over */
       
        /* Stop any new angular velocity being applied */
        hero.physicsBody?.allowsRotation = false
        
        /* Reset angular velocity */
        hero.physicsBody?.angularVelocity = 0
        
        /* Stop hero flapping animation */
        hero.removeAllActions()
        
        /* Create our hero death action */
        let heroDeath = SKAction.run({
            
            /* Put our hero face down in the dirt */
            self.hero.zRotation = CGFloat(-90).degreesToRadians()
        })
        
        /* Run action */
//        hero.run(heroDeath){
//            self.hero.removeFromParent()
//        }
        
        
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "splash", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            splash = try AVAudioPlayer(contentsOf: url)
            guard let player = splash else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
     func addEnemy () {
        
        let minValue = self.size.width / 8;
        let maxValue = self.size.width-20;
        let spawnPoint = UInt32(maxValue - minValue);
        
        Enemy = SKSpriteNode(imageNamed: "Mushroom_1")
        Enemy.size = CGSize(width: 38, height: 36)
        
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: 200/*self.size.height*/)
        self.addChild(Enemy)
        
//        let min: CGFloat = 15.0
//        let max: CGFloat = 200.0
//        let randomCGFloatBetweenMinAndMax2 = CGFloat(arc4random_uniform(UInt32(max-min)) + UInt32(min))
    }
 
}
