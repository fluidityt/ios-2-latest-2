//
//  GameScene.swift
//  Pong
//
//  Created by James Kirkwood on 17/03/2017.
//  Copyright © 2017 James Kirkwood. All rights reserved.
//

import SpriteKit
import GameplayKit
class GameScen2e: SKScene {
  
  let paddle = SKSpriteNode()
  let maximumRotation = CGFloat(45)
  
  override func didMove(to view: SKView) {
    paddle.color = .blue
    paddle.size = CGSize(width: 200, height: 15)
    
    let deg45 = CGFloat(0.785398)
    let degNeg45 = -deg45
    
    let constraint = [SKConstraint.zRotation(SKRange(lowerLimit: degNeg45, upperLimit: deg45))]
    paddle.constraints = constraint
    
    addChild(paddle)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let location     = touches.first?.location(in: self)         else { return }
    guard let lastLocation = touches.first?.previousLocation(in: self) else { return }
    guard location.y < self.frame.midY                                 else { return }
    
    // Our vertical plots:
    let yVal  = location.y
    let lastY = lastLocation.y
    
    // How much we moved in a certain direction this time:
    let deltaY = yVal - lastY
    
    // This value represents 100% of a 45deg angle:
    let oneHundredPercent = self.frame.height/2
    assert(oneHundredPercent != 0)
    
    // The % of total that we moved of 100%Val
    let absY = abs(deltaY)
    let radToDegFactor = CGFloat(0.01745329252)
    let multiplier = ((absY / oneHundredPercent) * radToDegFactor)
    
    let sensitivity = CGFloat(3)
    let amountToRotate = maximumRotation * (multiplier * sensitivity)
    
    // Rotate the correct amount in the correct direction:
    if deltaY > 0 {
      // Rotate counter-clockwise:
      paddle.run(.rotate(byAngle: amountToRotate, duration: 0))
    } else {
      // Rotate clockwise:
      paddle.run(.rotate(byAngle: -amountToRotate, duration: 0))
    }
    
  }
}

class GameScene: SKScene {
  
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var arrow1 = SKSpriteNode()
  
    var topLabel = SKLabelNode()
    var bottomLabel = SKLabelNode()
    
    var backgroundColorEasy = UIColor(red: 50/255.0, green: 189/255.0, blue: 18/255.0, alpha: 1.0)
    var backgroundColorHard = UIColor(red: 204/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
    var backgroundColor2Player = UIColor(red: 65/255.0, green: 88/255.0, blue: 255/255.0, alpha: 1.0)

    var score = [Int]()
  
    let maximumRotation = CGFloat(45)
  
    override func didMove(to view: SKView) {
        
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        bottomLabel = self.childNode(withName: "bottomLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 50
        arrow1.position.x = (self.frame.width / 2) - 25
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        startGame()
    }
    
    func startGame() {
        score = [0,0]
        topLabel.text = "\(score[1])"
        bottomLabel.text = "\(score[0])"
        ball.physicsBody!.applyImpulse(CGVector(dx: 10.0, dy: 10.0))
    }

    
    func addScore(playerWhoWon:SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == main {
            score[0] += 1
           ball.physicsBody!.applyImpulse(CGVector(dx: 10.0, dy: 10.0))
            
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody!.applyImpulse(CGVector(dx: -10.0, dy: -10.0))
            
        }
        topLabel.text = "\(score[1])"
        bottomLabel.text = "\(score[0])"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)

            if currentGameType == .player2{
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.05))
                    
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
            if currentGameType == .wobble{
                main.zRotation = (location.y)/512
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if currentGameType == .player2{
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.05))
                
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.05))
            }
            
            if currentGameType == .wobble{
              
              
              
              
              
                main.zRotation = (location.y)/512
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentGameType {
        case .easy:
             enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1))
             self.backgroundColor = backgroundColorEasy
            break
        case .wobble:
             enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
             self.backgroundColor = backgroundColorHard
            break
        case .player2:
            self.backgroundColor = backgroundColor2Player
            break
        }
        
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        
            }
        else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        
            }
    
    }
}
