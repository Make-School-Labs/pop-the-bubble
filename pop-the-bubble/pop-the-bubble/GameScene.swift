//
//  GameScene.swift
//  pop-the-bubble
//
//  Created by Eliel Gordon on 8/3/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var timer = Timer()
    var points = 0
    var pointsLabel = SKLabelNode()
    
    /// Called when a scene is ready for display
    /// Calls a function to generate a random bubble every few seconds
    override func didMove(to view: SKView) {
        setupPointsLabel()
        generateBubbleIn()
    }
    
    /// Set defaults for point label
    /// Adds pointsLabel to scene
    func setupPointsLabel() {
        guard let scene = scene else {return}
        
        pointsLabel.fontSize = 30
        updatePoints(points: points)
        
        // Position pointsLabel in scene
        // Place on the upper left corner
        // Adds half the width of the label because the anchor of the label is in its center
        let xPos = scene.frame.minX + (pointsLabel.frame.size.width / 2)
        let yPos = scene.frame.minY + (pointsLabel.frame.size.height + 25)
        
        let pointPosition = CGPoint(x: xPos, y: yPos)
        
        let pointsLocationInScene = scene.convertPoint(fromView: pointPosition)
        
        pointsLabel.position = pointsLocationInScene
        
        // Add as a child of scene
        addChild(pointsLabel)
    }
    
    /// Generates a bubble every few seconds
    func generateBubbleIn() {
        let timeInterval = TimeInterval(Float.random(in: 0.5...1.2))
        
        // Setup a timer to run randomly between every 0.5 to 1.2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { _ in
            
            let bubble = self.generateBubble()
            
            // Add bubble to the current game scene
            self.addChild(bubble)
            
            // Move bubble to top
            self.moveBubbleToTop(bubble: bubble)
        })
    }
    
    /// Generates a bubble at a random position
    ///
    /// - Returns: A Bubble
    func generateBubble() -> SKShapeNode {
        guard let scene = scene else {fatalError()}
        // Create a Bubble with a random size from 30 - 100 points radius
        let bubble = SKShapeNode(
            circleOfRadius: CGFloat.random(in: 30...100)
        )
        
        bubble.name = "Bubble"
        
        // Generate a random color
        let bubbleColor = UIColor(
            hue: CGFloat.random(in: 0...360),
            saturation: CGFloat(Int.random(in: 30...100)),
            brightness: CGFloat.random(in: 60...100),
            alpha: 1
        )
        
        bubble.fillColor = bubbleColor
        
        // The X position of the bubble
        // Start at a random x position
        let bubbleHalfWidth = (bubble.frame.size.width / 2)
        let leadingXPos = scene.frame.minX + bubbleHalfWidth
        let trailingXPos = scene.frame.maxX - bubbleHalfWidth
        let xPos = CGFloat.random(in: leadingXPos...trailingXPos)
        
        // The Y position of the bubble
        let bubbleHeight = (bubble.frame.size.height)
        let yPos = scene.frame.maxY + bubbleHeight
        
        let bubblePoint = CGPoint(x: xPos, y: yPos)
        
        let bubblePositionInScene = scene.convertPoint(fromView: bubblePoint)
        
        bubble.position = bubblePositionInScene
        
        return bubble
    }
    
    
    /// Moves a created bubble to the top of the screen
    /// Removes the bubble from the screen when complete
    /// - Parameter bubble: A Bubble (SKShapeNode)
    func moveBubbleToTop(bubble: SKShapeNode) {
        guard let topPos = scene?.view?.frame.minY
            else {return}
        
        let destinationY = topPos - bubble.frame.size.height
        let destinationPoint = CGPoint(x: bubble.frame.origin.x, y: destinationY)
        
        let locationInScene = scene!.convertPoint(fromView: destinationPoint)
        
        let translateAction = SKAction.move(
            to: locationInScene,
            duration: TimeInterval(Float.random(in: 1.0...1.5))
        )

        // Remove the bubble when it reaches the top of the screen
        // Deduct points if bubble reaches top without a tap
        bubble.run(translateAction) {
            bubble.removeFromParent()
            
            self.points -= 1
            self.updatePoints(points: self.points)
            
            if self.isGameOver() {
                self.handleGameOver(won: false)
            }
        }
        
    }
    
    func updatePoints(points: Int) {
        pointsLabel.text = "Points: \(points)"
    }
    
    func handleGameOver(won: Bool) {
        let gameOverScene = GameOverScene(
            size: self.size,
            won: won
        )
        
        self.view?.presentScene(gameOverScene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        handleTouch(touch: touch)
    }
    
    func handleTouch(touch: UITouch) {
        // User touched a bubble
        guard let bubble = touchedABubble(touch: touch)
            else {return}
        
        // Increment points
        points += 1
        updatePoints(points: points)
        bubble.removeFromParent()
    }
    
    func touchedABubble(touch: UITouch) -> SKNode? {
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        guard touchedNode.name == "Bubble" else {return nil}
        
        return touchedNode
    }
    
    func isGameOver() -> Bool {
        return points < 0
    }
}
