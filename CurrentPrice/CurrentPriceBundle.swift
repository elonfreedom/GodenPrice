//
//  CurrentPriceBundle.swift
//  CurrentPrice
//
//  Created by elon on 2025/10/29.
//

import WidgetKit
import SwiftUI

@main
struct CurrentPriceBundle: WidgetBundle {
    var body: some Widget {
        CurrentPrice()
        CurrentPriceControl()
        CurrentPriceLiveActivity()
    }
}
