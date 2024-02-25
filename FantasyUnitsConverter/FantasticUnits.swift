//
//  FantasticUnits.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 20.02.24.
//

import Foundation

enum FantasticUnits: CaseIterable {

    static var allCases: [FantasticUnits] {
        return [.parrots, .boas, .meters, .horsePower, .donkeyPower, .hours, .hardTicket, .shakilOnealMeter, .inCupsOfCoffee, .realSecond, .moscowSecond, .cutenessInKittens, .cutenessInPuppies, .cutenessInParrots]
    }

    // длина
    case parrots // в попугаях
    case boas // в удавах
    case meters // в метрах

    // мощность
    case horsePower // в лошадиных силах
    case donkeyPower // в осликах

    // сложность
    case hours
    case hardTicket // 16 часов работы
    case shakilOnealMeter // переноска Шакила О'Нила на 1 метр
    case inCupsOfCoffee // в чашечках кофе

    // время
    case realSecond
    case moscowSecond // одна московская секунда определяется как промежуток времени между включением зеленого сигнала светофора и сигналом машины стоящей позади.

    // милота
    case cutenessInKittens
    case cutenessInPuppies
    case cutenessInParrots

    static func possibleConversions(for unit: FantasticUnits) -> [FantasticUnits] {
        switch unit {
            // длина
        case .parrots, .boas, .meters:
            return [.parrots, .boas, .meters]

            // мощность
        case .horsePower, .donkeyPower:
            return [.horsePower, .donkeyPower]

            // сложность
        case .hours, .hardTicket, .shakilOnealMeter, .inCupsOfCoffee:
            return [.hours, .hardTicket, .shakilOnealMeter, .inCupsOfCoffee]

            // время
        case .realSecond, .moscowSecond:
            return [.realSecond, .moscowSecond]

            // милота
        case .cutenessInKittens, .cutenessInPuppies, .cutenessInParrots:
            return [.cutenessInKittens, .cutenessInPuppies, .cutenessInParrots]
        }
    }

    var title: String {
        switch self {
        case .parrots:
            "Длина в попугаях"
        case .boas:
            "Длина в удавах"
        case .meters:
            "Длина в метрах"
        case .horsePower:
            "Мощность в лошадиных силах"
        case .donkeyPower:
            "Мощность в осликах"
        case .hours:
            "Сложность в часах работы"
        case .hardTicket:
            "Сложность в тикетах"
        case .shakilOnealMeter:
            "Сложность в переноске Шакила О'Нила на 1 метр"
        case .inCupsOfCoffee:
            "Сложность в чашках кофе"
        case .realSecond:
            "Реальная секунда"
        case .moscowSecond:
            "\"Московская\" секунда"
        case .cutenessInKittens:
            "Милота в котятах"
        case .cutenessInPuppies:
            "Милота в щеночках"
        case .cutenessInParrots:
            "Милота в попугайчиках"
        }
    }

}
