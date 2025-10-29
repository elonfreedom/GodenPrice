//
//  Item.swift
//  GodenPrice
//
//  Created by elon on 2025/10/29.
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
