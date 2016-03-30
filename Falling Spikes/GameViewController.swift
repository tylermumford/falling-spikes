//
//  GameViewController.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 2/10/16.
//  Copyright (c) 2016 Mindful Code. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let v = view as? SKView {
            let s = MenuScene()
            print(s.scaleMode)
            s.scaleMode = .AspectFit
            v.presentScene(s)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
