//
//  HealthBar.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 23/11/2022.
//

import Foundation
import SpriteKit

class HealthBar: SKSpriteNode {
    
    private var maxWidth: CGFloat
    private weak var player: Player?
    private var healthText: SKLabelNode
    
    init(screenSize: CGSize, playerObject: Player) {
        maxWidth = screenSize.width / 3
        self.player = playerObject
        healthText = SKLabelNode()
        super.init(texture: SKTexture(imageNamed: "Green"), color: UIColor.green, size: CGSize()) //initialize with empty size and texture
        player?.healthBar = self
        self.size = CGSize(width: maxWidth, height: 40)
        self.position = CGPoint(x: screenSize.width * -0.45, y: screenSize.height * 0.47 - self.size.height) //set position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        initiateLabelNode()
        initiateBorder()
        updateLabelNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initiateLabelNode() {
        guard let player = player else { return }
        let formattedHealth = String(format: "%.0f", player.health) //rounding to integers in a string
        let formattedMaxHealth = String(format: "%.0f", player.maxHealth)
        healthText.text = "\(formattedHealth) / \(formattedMaxHealth)"
        healthText.fontName = "Chalkduster"
        healthText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        healthText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center //align on the center
        healthText.fontSize = self.size.height / 2
        healthText.position = CGPoint(x: self.maxWidth / 2, y: self.size.height / 2)
        healthText.fontColor = .black
        self.addChild(healthText)
    }
    
    private func updateLabelNode() {
        guard let player = player else { return }
        let formattedHealth = String(format: "%.0f", player.health) //rounding to string integers
        let formattedMaxHealth = String(format: "%.0f", player.maxHealth)
        healthText.text = "\(formattedHealth) / \(formattedMaxHealth)"
    }
    
    private func initiateBorder() {
        let border = SKShapeNode(rect: CGRect(x: 0, y: 0, width: maxWidth, height: self.size.height))
        border.position = CGPoint(x: -maxWidth / 2, y: -self.size.height / 2) //position the border
        border.fillColor = .clear
        border.strokeColor = .black
        border.lineWidth = 4
        healthText.addChild(border)
    }
    
    func update() {
        guard let player = player else { return }
        self.size = CGSize(width: maxWidth * player.health / player.maxHealth, height: self.size.height)
        updateLabelNode()
    }
    
}

