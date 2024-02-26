//
//  ConversionHistory.swift
//  FantasyUnitsConverter
//
//  Created by Roman Smirnov on 26.02.2024.
//

import Foundation

protocol History {
    func addConversion(from fromUnit: FantasticUnits, to toUnit: FantasticUnits, value: Double)
    var conversionHistory: [ConversionEvent] { get }
}

final class ConversionHistory: History {
    private (set) var conversionHistory: [ConversionEvent] = []

    func addConversion(from fromUnit: FantasticUnits,
                       to toUnit: FantasticUnits,
                       value: Double) {
        let event = ConversionEvent(
            fromUnit: fromUnit,
            toUnit: toUnit,
            outputValue: value,
            timestamp: Date()
        )
        addRecordToHistory(event)
    }

    private func addRecordToHistory(_ event: ConversionEvent) {
        conversionHistory.append(event)
    }

    func clearHistory() {
        conversionHistory.removeAll()
    }

    func findInHistory(query: (ConversionEvent) -> Bool) -> [ConversionEvent] {
        conversionHistory.filter(query)
    }
}

