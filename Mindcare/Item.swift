//
//  Item.swift
//  Mindcare
//
//  Created by Mr.Kritchant on 27/11/2568 BE.
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
