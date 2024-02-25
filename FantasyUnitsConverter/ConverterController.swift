//
//  ConverterController.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

class ConverterController {

    static let shared = ConverterController()

    var view: UIViewController?

    var conversionHistory: [ConversionEvent] = []

    func convert(from unit: FantasticUnits, to targetUnit: FantasticUnits, amount value: Double) -> Double {

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
            let alertController = UIAlertController(
                title: "Ошибка",
                message: "Конвертация между этими единицами не поддерживается",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                alertController.dismiss(animated: false)
            }
            alertController.addAction(okAction)

            view?.present(alertController, animated: true)

            // to log an error
            print("Конвертация между этими единицами не поддерживается")
            return value
        }

        let event = ConversionEvent(
            fromUnit: unit,
            toUnit: targetUnit,
            outputValue: outputValue,
            timestamp: Date()
        )
        addRecordToHistory(event)

        return outputValue
    }

    func addRecordToHistory(_ event: ConversionEvent) {
        conversionHistory.append(event)
    }

    func clearHistory() {
        conversionHistory.removeAll()
    }

    func findInHistory(query: (ConversionEvent) -> Bool) -> [ConversionEvent] {
        conversionHistory.filter(query)
    }

}


