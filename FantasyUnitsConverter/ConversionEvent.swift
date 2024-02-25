//
//  ConversionEvent.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 20.02.24.
//

import Foundation

struct ConversionEvent {
    var fromUnit: FantasticUnits
    var toUnit: FantasticUnits
    var outputValue: Double
    var timestamp: Date

    func description() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return """
        Конвертация из \(fromUnit) в \(toUnit). \
        Входное значение 1: \(fromUnit), \
        Входное значение 2: \(toUnit), \
        Выходное значение: \(outputValue). \
        Дата: \(formatter.string(from: timestamp))
        """
    }
}
