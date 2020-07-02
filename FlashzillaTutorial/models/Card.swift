//
//  Card.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/29/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static var example: Card {
        Card(prompt: "Who am I", answer: "Card")
    }
}


