//
//  HighScores.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 4/19/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import Foundation

class HighScores {
    
    static private var scores: [Int] = {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.arrayForKey(defaultsKey) as! [Int]
    }()
    static private var sorted: [Int]?
    
    
    static let defaultsKey = "highScores"
    static var allScores: [Int] {
        if let s = sorted {
            return s
        } else {
            sorted = scores.sort(>)
            return sorted!
        }
    }
    
    
    static func recordScore(score: Int) {
        guard score > 3 else { return }
        print("Recording score: \(score)")
        sorted = nil
        scores.append(score)
        // TODO: Record time, maybe player name
    }
    
    static func isHighestScore(score: Int) -> Bool {
        return score > allScores.first ?? Int.min
    }
    
    static func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(allScores, forKey: defaultsKey)
    }
    
}