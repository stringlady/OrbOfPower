//
//  GameScene.swift
//  OrbOfPower
//
//  Created by Anaya Bussey on 8/4/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit

enum GameSceneState {
    case active, gameOver
}


// Generate a random index




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
   
    
    let scrollSpeed: CGFloat = 100
    var scrollLayer: SKNode!
    let fixedDelta: CFTimeInterval = 2.0 / 60.0 /* 60 FPS */
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
    var platformSource: SKNode!
    var platformLayer: SKNode!
    var currentScore = 0
    var jump = false
    var bound: SKSpriteNode!
    var bound1: SKSpriteNode!
    var playGame: MSButtonNode!
    var stonesOnScreen = 1
    var totalStones: Int = 0
    var stoneDensity = 1.8
    var stones: [SKSpriteNode]!
    var stoneScrollLayer: SKNode!
    var Enemy2: SKSpriteNode!
    var enemy1: SKSpriteNode!
    
    
    
    
    
    
    
    
    
//    func gameOver() {
//        if currentScore > highScore {
//            saveHighScore()
//        }
//    }
        /* GAME OVER */
//        let skView = self.view as SKView!
//        guard let scene = GameScene(fileNamed:"GameOver") as GameScene! else {
//            return
//        }
        /* Ensure correct aspect mode */
//        scene.scaleMode = .aspectFill
//        
        /* Restart GameScene */
//        skView?.presentScene(scene)
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "splash", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            splash = try AVAudioPlayer(contentsOf: url)
            guard let hero = splash else { return }
            
            hero.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        platformLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes */
        for platform in platformLayer.children as! [SKReferenceNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let platformPosition = platformLayer.convert(platform.position, to: self)
            
            /* Check if obstacle has left the scene */
            if platformPosition.x <= -26 {
                // 26 is one half the width of an obstacle
                
                /* Remove obstacle node from obstacle layer */
                platform.removeFromParent()
            }
        }
            
        
        
        /* Time to add a new obstacle? */
        if timer >= 4.5 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newPlatform = platformSource.copy() as! SKNode
            platformLayer.addChild(newPlatform)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: 462, y: CGFloat.random(min: 92, max: 250))
            
            /* Convert new node position back to obstacle layer space */
            newPlatform.position = self.convert(randomPosition, to: platformLayer)
            
            // Reset spawn timer
            timer = 0
        }
        
        
        
    }
    
//    func spawnNpc() {
//    
//    for stone in stoneScrollLayer.children {
//    
//    /* Get obstacle node postion, convert node position to scene space */
//    let npcPosition = stoneScrollLayer.convert(stone.position, to: self)
//    
//    /* Check if obstacle has left the scene */
//    if npcPosition.x <= -40 {
//    
//    /* Remove obstacle node from obstacle layer */
//    stone.removeFromParent()
//    }
//        }
//    
//    if timer >= stoneDensity {
//    print(stonesOnScreen)
//    //change max number to npcList.count for ALL sprites at once, change it to npcOnScreen for incremental increase of sprites
//        let randomNpcIndex = randomInteger(min: 0, max: stonesOnScreen)
//    if randomNpcIndex >= 3 {
//    print("should spawn mushroom etc")
//    }
//    
//    let newEnemy = stones[randomNpcIndex].copy() as! SKSpriteNode //newEnemy is the first child
//    
//    stoneScrollLayer.addChild(newEnemy) //adds new enemy
//    
//    //            let eggPosition = self.egg.convert(self.egg.position, to: self)
//    let randomPosition = CGPoint(x: 800 , y: 80)
//    
//    newEnemy.position = self.convert(randomPosition, to: stoneScrollLayer)
//    
//    
//    // Reset spawn timer
//    timer = 0
//    
//    }
//}
    
    func addEnemy () {
        
        let minValue = self.size.width / 8;
        let maxValue = self.size.width-20;
        let spawnPoint = UInt32(maxValue - minValue);
        
        Enemy = SKSpriteNode(imageNamed: "green")
        Enemy.size = CGSize(width: 38, height: 36)
        
        Enemy2 = SKSpriteNode(imageNamed: "pink")
        Enemy2.size = CGSize(width: 38, height: 36)
        if timer >= 10 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newPlatform = Enemy.copy() as! SKSpriteNode
            platformLayer.addChild(newPlatform)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            Enemy.position = CGPoint(x: CGFloat.random(min: 80, max: 250), y: CGFloat.random(min: 92, max: 250)/*self.size.height*/)
            
            /* Convert new node position back to obstacle layer space */
            newPlatform.position = self.convert(Enemy.position, to: platformLayer)
            
            // Reset spawn timer
            timer = 0
        }
        
        if timer >= 15 {
            /* Create a new obstacle by copying the source obstacle */
            let newPlatform = Enemy2.copy() as! SKSpriteNode
            platformLayer.addChild(newPlatform)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            Enemy2.position = CGPoint(x: CGFloat.random(min: 80, max: 250), y: CGFloat.random(min: 92, max: 250)/*self.size.height*/)
            
            /* Convert new node position back to obstacle layer space */
            newPlatform.position = self.convert(Enemy2.position, to: platformLayer)
            
            // Reset spawn timer
            timer = 0
        }
        
        //        let min: CGFloat = 15.0
        //        let max: CGFloat = 200.0
        //        let randomCGFloatBetweenMinAndMax2 = CGFloat(arc4random_uniform(UInt32(max-min)) + UInt32(min))
    }


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
        landOrb = self.childNode(withName: "//landOrb") as! SKSpriteNode
        waterOrb = self.childNode(withName: "//waterOrb") as! SKSpriteNode
        // shootOrb = self.childNode(withName: "shootOrb") as! SKSpriteNode
        //landTransform = self.childNode(withName: "landTransform") as! SKSpriteNode
        //waterTransform = self.childNode(withName: "waterTransform") as! SKSpriteNode
        platformSource = self.childNode(withName: "//platform")
        platformLayer = self.childNode(withName: "platformLayer")
        bound = self.childNode(withName: "bound") as! SKSpriteNode
        bound1 = self.childNode(withName: "bound1") as! SKSpriteNode
        playGame = self.childNode(withName: "playGame") as! MSButtonNode
        
        
        /* Setup restart button selection handler */
        buttonRestart.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
            
        }
            
            /* Setup restart button selection handler */
            playGame.selectedHandler = {
                
                /* Grab reference to our SpriteKit view */
                let skView = self.view as SKView!
                
                /* Load Game scene */
                let scene = MainMenu(fileNamed:"MainMenu") as MainMenu!
                
                /* Ensure correct aspect mode */
                scene?.scaleMode = .aspectFill
                
                /* Restart game scene */
                skView?.presentScene(scene)
                
            }
        
        /* Hide restart button */
        buttonRestart.state = .MSButtonNodeStateHidden
            
        // Hide return
        playGame.state = .MSButtonNodeStateHidden
        
        jumpAction = SKAction.sequence([jumpUp, fallBack])
            
        //stones = [landOrb, waterOrb]
            
        //totalStones = stones.count
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
        
        func saveHighScore() {
            UserDefaults().set(GameScene.self, forKey: "HIGHSCORE")
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
        
        //Process platforms
        updateObstacles()
        
        timer+=fixedDelta
        
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
        
       // addEnemy()
        
        timer += fixedDelta
        
        pointLabel.text = String(Int(timer))
        
       // updateObstacles1()
        
        //updateObstacles2()
        
        //spawnNpc()
        
        //addEnemy()
    }
    
    func scrollWorld() {
        
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for landOrb in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(landOrb.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -landOrb.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + landOrb.size.width, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                landOrb.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Hero touches anything, game over */
        
        
        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if (contactA.node?.name == "platform" || contactB.node?.name == "platform") && currentType == .land {
            hero.texture = SKTexture(imageNamed: "landTransform")
        }
        
        /* Did our hero pass through the 'goal'? */
        if (contactA.node?.name == "water" || contactB.node?.name == "water") && currentType == .land {
            self.hero.removeFromParent()
            
            playSound()
            
            gameState = .gameOver
            
            /* Show restart button */
            playGame.state = .MSButtonNodeStateActive
            
            playGame.alpha = 1
            
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
             playSound()
            hero.texture = SKTexture(imageNamed: "seaTransform")
        }
        
        if (contactA.categoryBitMask == 4 || contactB.categoryBitMask == 4) && currentType == .land {
            hero.texture = SKTexture(imageNamed: "landTransform")
        }
        
        
        if (contactA.node?.name == "bound" || contactB.node?.name == "bound") {
            self.hero.removeFromParent()
            
            gameState = .gameOver
            
            /* Show restart button */
            playGame.state = .MSButtonNodeStateActive
            
            playGame.alpha = 1
            
            /* Show restart button */
            buttonRestart.state = .MSButtonNodeStateActive
            
            buttonRestart.alpha = 1
            
            /* We can return now */
            return
            
        }
        
        if (contactA.node?.name == "bound1" || contactB.node?.name == "bound1")  {
            self.hero.removeFromParent()
            
            gameState = .gameOver
            
            /* Show restart button */
            playGame.state = .MSButtonNodeStateActive
            
            playGame.alpha = 1
            
            /* Show restart button */
            buttonRestart.state = .MSButtonNodeStateActive
            
            buttonRestart.alpha = 1
            
            /* We can return now */
            return
            
        }
        
        if (contactA.node?.name == "platform" || contactB.node?.name == "platform") && currentType == .water {
            self.hero.removeFromParent()
            
            gameState = .gameOver
            
            /* Show restart button */
            playGame.state = .MSButtonNodeStateActive
            
            playGame.alpha = 1
            
            /* Show restart button */
            buttonRestart.state = .MSButtonNodeStateActive
            
            buttonRestart.alpha = 1
            
            /* We can return now */
            return
            
        }
        
        
        
        /* Ensure only called while game running */
        if gameState != .active { return }
        
        
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
        
        
    
    

    
    
    }



}
