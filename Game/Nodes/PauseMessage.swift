//
//  PauseMessage.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 07/02/2023.
//

import Foundation
import SpriteKit

class PauseMessage: SKLabelNode {
    
    override init() {
        super.init()
        self.text = "Press Pause Button Again to Resume"
        self.fontColor = .black
        self.fontName = "Chalkduster"
        self.fontSize = 20
        self.zPosition = 100
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.name = "PauseMessage"
        attachBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attachBackground() {
        let size = CGSize(width: SceneInfo.size.width * 0.5, height: SceneInfo.size.height * 0.5) //half the size of screen
        let background = SKShapeNode(rectOf: size, cornerRadius: 10)
        background.fillColor = UIColor(white: 1, alpha: 0.8) //translucent background
        background.zPosition = -1 //behind the text
        self.addChild(background)
    }
    
}
