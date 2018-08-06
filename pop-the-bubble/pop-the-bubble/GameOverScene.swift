//
//  GameOverScene.swift
//  pop-the-bubble
//
//  Created by Eliel Gordon on 8/6/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//
import SpriteKit

class GameOverScene: SKScene {
    var won: Bool
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
        
        backgroundColor = SKColor.white
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        guard let scene = scene else {fatalError()}
        let message = self.won ? "You Won! 😁" : "You Lost 🙁"
        
        // Game status label
        let label = SKLabelNode()
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // Restart Game Button
        let restartButton = SKShapeNode(rectOf: CGSize(width: 230, height: 45))
        restartButton.fillColor = SKColor.orange
        restartButton.position = CGPoint(x: label.position.x, y: label.position.y - restartButton.frame.size.height - 30)
        let restartLabel = SKLabelNode(text: "Play Again")
        
        addChild(restartButton)
        restartButton.addChild(restartLabel)
        
        let labelPos = CGPoint(x: restartButton.frame.size.width/2, y: restartButton.frame.size.height/2)
        //        let labelPosInButton = scene.convertPoint(fromView: labelPos)
        restartLabel.position = labelPos
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene(size: size)
        self.view?.presentScene(scene)
    }
}
