//
//  ConverterController.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

enum ConversionError: Error {
    case unsupportedPair
}

class ConverterController {

    static let shared = ConverterController()

    func convert(from unit: FantasticUnits, to targetUnit: FantasticUnits, amount value: Double) throws -> Double {

        var outputValue: Double = 0.0

        // Пример конвертации, не отражающий реальную логику
        switch (unit, targetUnit) {

        case (.parrots, .boas):
            outputValue = value / 38
        case (.boas, .parrots):
            outputValue = value * 38
        case (.meters, .parrots):
            outputValue = value * 11
        case (.parrots, .meters):
            outputValue = value / 11
        case (.meters, .boas):
            outputValue = value / 5.0
        case (.boas, .meters):
            outputValue = value * 5.0
            
        case (.hours, .hardTicket):
            outputValue = value / 16.0
        case (.hardTicket, .hours):
            outputValue = value * 16
        case (.hours, .shakilOnealMeter):
            outputValue = value / 16
        case (.shakilOnealMeter, .hours):
            outputValue = value * 16
        case (.hours, .inCupsOfCoffee):
            outputValue = value * 4
        case (.inCupsOfCoffee, .hours):
            outputValue = value / 4
        case (.hardTicket, .shakilOnealMeter):
            outputValue = value
        case (.shakilOnealMeter, .hardTicket):
            outputValue = value
        case (.hardTicket, .inCupsOfCoffee):
            outputValue = value * 4
        case (.inCupsOfCoffee, .hardTicket):
            outputValue = value / 4
        case (.shakilOnealMeter, .inCupsOfCoffee):
            outputValue = value * 64
        case (.inCupsOfCoffee, .shakilOnealMeter):
            outputValue = value / 64

        case (.horsePower, .donkeyPower):
            outputValue = value * 3.0
        case (.donkeyPower, .horsePower):
            outputValue = value / 3.0

            // Cuteness conversions
        case (.cutenessInKittens, .cutenessInPuppies):
            outputValue = value / 3.0
        case (.cutenessInPuppies, .cutenessInKittens):
            outputValue = value * 3.0
        case (.cutenessInKittens, .cutenessInParrots):
            outputValue = value * 15.0
        case (.cutenessInParrots, .cutenessInKittens):
            outputValue = value / 15.0
        case (.cutenessInParrots, .cutenessInPuppies):
            outputValue = value * 5.0
        case (.cutenessInPuppies, .cutenessInParrots):
            outputValue = value / 5.0 

        case (.moscowSecond, .realSecond):
            outputValue = value / 1000
        case (.realSecond, .moscowSecond):
            outputValue = value * 1000.0

        default:
            throw(ConversionError.unsupportedPair)
        }

        return outputValue
    }
}


