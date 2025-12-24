//
//  Item.swift
//  diablo
//
//  Created by Gary Phelps on 12/23/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
