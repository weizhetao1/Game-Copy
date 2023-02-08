//
//  GameScene.swift
//  Game
//
//  Created by Tao, Weizhe (Coll) on 14/09/2022.
//

import Foundation
import SpriteKit
import GameplayKit

enum NewGameCause {
    case completed, died
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: Player! //There must be a player node, whether dead or alive
    var healthBar: HealthBar! //initiate health bar
    private var cameraNode = SKCameraNode()
    private var leftTouched: Bool = false {
        didSet {
            if !leftTouched {
                player.stopHorizontalMovement()
            }
        }
    }
    private var rightTouched: Bool = false {
        didSet {
            if !rightTouched {
                player.stopHorizontalMovement()
            }
        }
    }
    var enemiesLeft: Int = 0 {
        didSet {
            if enemiesLeft == 0 {
                newGame(cause: .completed)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        SceneInfo.size = self.size
        setUpPhysics()
        setUpPlayer()
        setUpBackground()
        setUpMap()
        setUpUI()
    }
    
    private func setUpBackground() {
        backgroundColor = UIColor.white
        cameraNode.position = CGPoint(x: size.width / 2 , y: size.width / 2)
        cameraNode.zPosition = 50
        self.camera = cameraNode
        cameraNode.xScale = 0.9
        cameraNode.yScale = 0.9
        addChild(cameraNode)
    }
    
    private func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: PhysicsWorldBaseStats.gravity)
        physicsWorld.speed = 1.0
        physicsWorld.contactDelegate = self //informs the class itself upon contacts
    }
    
    private func setUpPlayer() {
        player = Player(position: CGPoint(x: size.width * 0.25, y: size.height * 0.5), zPosition: 1)
        addChild(player)
    }
    
    private func setUpMap() {
        let mapGenerator = MapGenerator()
        mapGenerator.setUpTileMap(fileNamed: "Map1.sks", scene: self)
        addChild(mapGenerator.tileMap)
        enemiesLeft = mapGenerator.numberOfEnemiesSpawned
    }
    
    private func setUpUI() {
        let fireButton = ButtonNode(type: .rangedAttack, action: player.shootBullet)
        let buttonLeft = ButtonNode(type: .moveLeft, action: { self.leftTouched = true }, endAction: { self.leftTouched = false })
        let buttonRight = ButtonNode(type: .moveRight, action: { self.rightTouched = true }, endAction: { self.rightTouched = false })
        let jumpButton = ButtonNode(type: .jump, action: player.jump)
        let meleeButton = ButtonNode(type: .meleeAttack, action: player.meleeAttack)
        let slowButton = ButtonNode(type: .timeSlow, action: self.timeSlow)
        let pauseButton = ButtonNode(type: .pause, action: self.togglePause)
        
        cameraNode.addChild(fireButton)
        cameraNode.addChild(jumpButton)
        cameraNode.addChild(buttonLeft)
        cameraNode.addChild(buttonRight)
        cameraNode.addChild(meleeButton)
        cameraNode.addChild(slowButton)
        cameraNode.addChild(pauseButton)
        
        healthBar = HealthBar(screenSize: self.size, playerObject: player)
        cameraNode.addChild(healthBar) //add to UI layer (camera node)
    }
    
    func newGame(cause: NewGameCause) {
        print("new game")
        var endMessage = Message()
        switch cause {
        case .completed:
            endMessage = Message(text: Messages.completeMessage, name: "EndMessage")
        case .died:
            endMessage = Message(text: Messages.diedMessage, name: "EndMessage")
        }
        self.cameraNode.addChild(endMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { //called after 8 seconds
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transitionAnimation = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(newScene, transition: transitionAnimation) //present new scene to the view
        }
    }
    
    func timeSlow() {
        self.physicsWorld.speed = PhysicsWorldBaseStats.timeSlowFactor //slows down the world
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: PhysicsWorldBaseStats.gravity / pow(PhysicsWorldBaseStats.timeSlowFactor, 2)) //increase gravity
        self.player.speedFactor = 1 / PhysicsWorldBaseStats.timeSlowFactor //speeds up the player
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { //called after 10 seconds
            self.physicsWorld.speed = 1
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: PhysicsWorldBaseStats.gravity) //set back to base gravity
            self.player.speedFactor = 1
        }
    }
    
    func togglePause() {
        if self.isPaused == false {
            let pauseMessage = Message(text: Messages.pauseMessage, name: "PauseMessage")
            self.cameraNode.addChild(pauseMessage)
            self.isPaused = true
        } else {
            self.isPaused = false
            self.cameraNode.childNode(withName: "PauseMessage")?.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if leftTouched && rightTouched {
            return //do nothing if both right and left are touched
        } else if leftTouched {
            player.moveLeft()
        } else if rightTouched {
            player.moveRight()
        }
        
        updateCameraPosition()
        updateEnemies()
    }
    
    private func updateCameraPosition() {
        cameraNode.position = player.position //set camera position to player position
    }
    
    private func updateEnemies() {
        self.enumerateChildNodes(withName: "enemy") {
            node, _ in //Iterates through list of enemies
            if let enemy = node as? Enemy { //make sure that they are of type Enemy
                enemy.update()
            }
        }
    }
    
    private func destroy(node: SKNode?) {
        node?.removeFromParent()
    }
    
    private func inContact(contact: SKPhysicsContact, _ name1: String, _ name2: String) -> Bool {
        if (contact.bodyA.node?.name == name1 && contact.bodyB.node?.name == name2) || (contact.bodyA.node?.name == name2 && contact.bodyB.node?.name == name1) {
            return true
        }
        return false
    }
    
    private func bulletContactTest(contact: SKPhysicsContact, nodeA: SKNode, nodeB: SKNode) -> (bullet: Bullet, otherNode: SKNode)? {
        //return (the bullet node, the other node) if bullet is involved, otherwide nil. (ordered with casted type)
        if contact.bodyA.categoryBitMask == PhysicsCategory.bullet {
            if let bullet = nodeA as? Bullet { //make sure it is of type bullet
                return (bullet, nodeB)
            }
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.bullet {
            if let bullet = nodeB as? Bullet { //make sure it is of type bullet
                return (bullet, nodeA)
            }
        }
        return nil
    }
    
    private func meleeContactTest(contact: SKPhysicsContact, nodeA: SKNode, nodeB: SKNode) -> (meleeWeapon: MeleeWeapon, otherNode: SKNode)? {
        //return (the melee weapon node, the other node) if melee weapon is involved, otherwide nil. (return is ordered with casted type)
        if contact.bodyA.categoryBitMask == PhysicsCategory.sword {
            if let meleeWeapon = nodeA as? MeleeWeapon { //make sure it is of type bullet
                return (meleeWeapon, nodeB)
            }
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.sword {
            if let meleeWeapon = nodeB as? MeleeWeapon { //make sure it is of type bullet
                return (meleeWeapon, nodeA)
            }
        }
        return nil
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return } //make sure 2 nodes exist for the contact
        if let bulletContact = bulletContactTest(contact: contact, nodeA: nodeA, nodeB: nodeB) {
            handleBulletContact(bulletContact: bulletContact)
        } else if let meleeContact = meleeContactTest(contact: contact, nodeA: nodeA, nodeB: nodeB) {
            handleMeleeContact(meleeContact: meleeContact)
        } else if inContact(contact: contact, "player", "ground") {
            player.inAir = false
        }
    }
    
    private func handleBulletContact(bulletContact: (bullet: Bullet, otherNode: SKNode)) {
        if let enemy = bulletContact.otherNode as? Enemy {
            enemy.takeDamage(of: PlayerBaseStats.bulletDamage) //let enemy take damage if involved in the collision
        } else if let player = bulletContact.otherNode as? Player {
            player.takeDamage(of: EnemyBaseStats.bulletDamage) //let player take damage if involved in the collision
        }
        destroy(node: bulletContact.bullet)
        return
    }
    
    private func handleMeleeContact(meleeContact: (meleeWeapon: MeleeWeapon, otherNode: SKNode)) {
        if let enemy = meleeContact.otherNode as? Enemy {
            enemy.takeDamage(of: PlayerBaseStats.meleeDamage) //let enemy take damage if involved in the collision
        } else if let player = meleeContact.otherNode as? Player {
            player.takeDamage(of: EnemyBaseStats.meleeDamage) //let player take damage if involved in the collision
        }
        return
    }
}
