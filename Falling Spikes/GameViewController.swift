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

    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet var rec: UITapGestureRecognizer!
    
    var score: Int = 0
    var scoreRecorded = false
    var scoreTimer: NSTimer?
    let runLoop = NSRunLoop.currentRunLoop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(pauseGame),
                       name: "pause",
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(resumeGame),
                       name: "resume",
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(quit),
                       name: "quit",
                       object: nil)
    }
    
    @IBAction func quit() {
        if !gameView.paused {
            gameOver()
        }
    }
    
    
    
    // MARK: Gameplay
    
    func startGame() {
        score = 0
        scoreLabel.text = "\(score)"
        gameOverLabel.hidden = true
        rec.enabled = false
        
        scoreTimer?.invalidate() // Just in case.
        scoreTimer = newScoreTimer()
        runLoop.addTimer(scoreTimer!, forMode: NSDefaultRunLoopMode)
        
        let s = GameScene(size: view.bounds.size)
        s.scaleMode = .AspectFill
        s.gameOverFunc = gameOver
        gameView.presentScene(s)
    }
    
    func pauseGame() {
        gameView.paused = true
        scoreTimer?.invalidate()
    }
    
    func resumeGame() {
        gameView.paused = false
        scoreTimer?.invalidate() // Just in case.
        scoreTimer = newScoreTimer()
        runLoop.addTimer(scoreTimer!, forMode: NSDefaultRunLoopMode)
    }
    
    func gameOver() {
        gameView.paused = true
        gameOverLabel.hidden = false
        rec.enabled = true
        
        scoreTimer?.invalidate()
        
        HighScores.recordScore(score)
        let defaults = NSUserDefaults.standardUserDefaults()
        let played = defaults.integerForKey("timesPlayed")
        defaults.setInteger(played + 1, forKey: "timesPlayed")
    }
    
    @IBAction func restart(sender: UITapGestureRecognizer) {
        startGame()
    }
    
    /// Increase the score and update the display.
    func increaseScore() {
        print("Score: \(score)")
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func newScoreTimer() -> NSTimer {
        let t = NSTimer(timeInterval: 1,
                        target: self,
                        selector: #selector(increaseScore),
                        userInfo: nil,
                        repeats: true)
        t.tolerance = 0.15
        return t
    }
    
}
