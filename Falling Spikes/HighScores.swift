//
//  HighScores.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 4/19/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import Foundation

typealias Score = (Int, date: String)

class HighScores {
    
    static private var scores: [Score]!
    static private var sorted: [Score]?
    
    static let dateFormat: NSDateFormatter = {
        let a = NSDateFormatter()
        a.dateStyle = .MediumStyle
        a.timeStyle = .ShortStyle
        return a
    }()
    
    
    static let defaultsKey = "highScores"
    static let defaultsKeyDates = "highScoreDates"
    static var allScores: [Score] {
        if let s = sorted {
            return s
        } else {
            if scores == nil { scores = [Score]() }
            sorted = scores.sort { $0.0 > $1.0 }
            return sorted!
        }
    }
    
    
    static func recordScore(score: Int) {
        guard score > 3 else { return }
        if scores == nil { scores = [Score]() }
        
        print("Recording score: \(score)")
        let date = dateFormat.stringFromDate(NSDate())
        sorted = nil
        scores.append((score, date))
    }
    
    static func isHighestScore(score: Int) -> Bool {
        return score > allScores.first?.0 ?? Int.min
    }
    
    static func fetch() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard let dates = defaults.arrayForKey(defaultsKeyDates) as? [String],
            saved = defaults.arrayForKey(defaultsKey) as? [Int] else {
                print("No saved scores found.")
                return
        }
        
        scores = [Score]()
        sorted = nil
        let combined = zip(saved, dates)
        for pair in combined {
            scores.append(pair as Score)
        }
    }
    
    static func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let values = allScores.map { $0.0 }
        let dates = allScores.map { $0.date }
        defaults.setObject(values, forKey: defaultsKey)
        defaults.setObject(dates, forKey: defaultsKeyDates)
    }
    
    static func clear() {
        scores = nil
        sorted = nil
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(defaultsKey)
        fetch()
    }
    
}