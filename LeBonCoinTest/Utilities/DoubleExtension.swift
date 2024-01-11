//
//  DoubleExtension.swift
//  LeBonCoinTest
//
//  Created by Mickaël Horn on 11/01/2024.
//

import Foundation

extension Double {
    func formattedBy2DigitsMax() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
}
