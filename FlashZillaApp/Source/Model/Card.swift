//
//  Card.swift
//  FlashZillaApp
//
//  Created by Danjuma Nasiru on 09/03/2023.
//

import Foundation

struct Card : Codable, Hashable {
    let prompt : String
    let answer : String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
