//
//  Stats.swift
//  FirebaseLogin
//
//  Created by Aleksa Dimitrijevic on 28.9.22..
//

import SwiftUI

// Sample Graph Model and Data

struct Stats: Identifiable{
    var id = UUID().uuidString
    var min: CGFloat
    var day: String
    var color: Color
}

var weekStats: [Stats] = [
    Stats(min: 100, day: "P", color: Color("BG")),
    Stats(min: 50, day: "U", color: Color("BG")),
    Stats(min: 30, day: "S", color: Color("BG")),
    Stats(min: 75, day: "Č", color: Color("BG")),
    Stats(min: 40, day: "P", color: Color("BG")),
    Stats(min: 35, day: "S", color: Color("BG")),
    Stats(min: 50, day: "N", color: Color("BG"))
]
