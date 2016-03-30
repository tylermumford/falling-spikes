//
//  ControlScheme.swift
//  Falling Spikes
//
//  Created by Tyler Mumford on 3/30/16.
//  Copyright © 2016 Mindful Code. All rights reserved.
//

import CoreGraphics


typealias MoveHandler = (to: CGFloat) -> Void

protocol ControlScheme {
    func addMoveHandler(_: MoveHandler)
}