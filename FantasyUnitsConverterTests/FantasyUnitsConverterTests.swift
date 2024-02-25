//
//  FantasyUnitsConverterTests.swift
//  FantasyUnitsConverterTests
//
//  Created by andrew mayer on 13.02.24.
//

import XCTest
@testable import FantasyUnitsConverter

final class FantasyUnitsConverterTests: XCTestCase {

    var converter: ConverterController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        converter = ConverterController.shared
        converter.clearHistory()
    }

    override func tearDownWithError() throws {
        converter = nil
        try super.tearDownWithError()
    }

    // MARK: - Conversion Tests

    func testParrotsToBoasConversion() {
        XCTAssertEqual(converter.convert(from: .parrots, to: .boas, amount: 1), 1/38)
    }

    func testBoasToParrotsConversion() {
        XCTAssertEqual(converter.convert(from: .boas, to: .parrots, amount: 1), 38)
    }

    func testMetersToParrotsConversion() {
        XCTAssertEqual(converter.convert(from: .meters, to: .parrots, amount: 1), 11)
    }

    func testMetersToBoasConversion() {
        XCTAssertEqual(converter.convert(from: .meters, to: .boas, amount: 1), 1/5.0)
    }

    func testHoursToHardTicketConversion() {
        XCTAssertEqual(converter.convert(from: .hours, to: .hardTicket, amount: 1), 1/16.0)
    }

    func testHardTicketToHoursConversion() {
        XCTAssertEqual(converter.convert(from: .hardTicket, to: .hours, amount: 1), 16)
    }

    func testHoursToShakilOnealMeterConversion() {
        XCTAssertEqual(converter.convert(from: .hours, to: .shakilOnealMeter, amount: 1), 1/16)
    }

    func testShakilOnealMeterToHoursConversion() {
        XCTAssertEqual(converter.convert(from: .shakilOnealMeter, to: .hours, amount: 1), 16)
    }

    func testHoursToInCupsOfCoffeeConversion() {
        XCTAssertEqual(converter.convert(from: .hours, to: .inCupsOfCoffee, amount: 1), 4)
    }

    func testInCupsOfCoffeeToHoursConversion() {
        XCTAssertEqual(converter.convert(from: .inCupsOfCoffee, to: .hours, amount: 1), 1/4)
    }

    func testHardTicketToShakilOnealMeterConversion() {
        XCTAssertEqual(converter.convert(from: .hardTicket, to: .shakilOnealMeter, amount: 1), 1)
    }

    func testShakilOnealMeterToHardTicketConversion() {
        XCTAssertEqual(converter.convert(from: .shakilOnealMeter, to: .hardTicket, amount: 1), 1)
    }

    func testHardTicketToInCupsOfCoffeeConversion() {
        XCTAssertEqual(converter.convert(from: .hardTicket, to: .inCupsOfCoffee, amount: 1), 4)
    }

    func testInCupsOfCoffeeToHardTicketConversion() {
        XCTAssertEqual(converter.convert(from: .inCupsOfCoffee, to: .hardTicket, amount: 1), 1/4)
    }

    func testShakilOnealMeterToInCupsOfCoffeeConversion() {
        XCTAssertEqual(converter.convert(from: .shakilOnealMeter, to: .inCupsOfCoffee, amount: 1), 64)
    }

    func testInCupsOfCoffeeToShakilOnealMeterConversion() {
        XCTAssertEqual(converter.convert(from: .inCupsOfCoffee, to: .shakilOnealMeter, amount: 1), 1/64)
    }

    // Cuteness Conversions
    func testCutenessInKittensToCutenessInPuppiesConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInKittens, to: .cutenessInPuppies, amount: 1), 1/3.0)
    }

    func testCutenessInPuppiesToCutenessInKittensConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInPuppies, to: .cutenessInKittens, amount: 1), 3.0)
    }

    func testCutenessInKittensToCutenessInParrotsConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInKittens, to: .cutenessInParrots, amount: 1), 15.0)
    }

    func testCutenessInParrotsToCutenessInKittensConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInParrots, to: .cutenessInKittens, amount: 1), 1/15.0)
    }

    func testCutenessInParrotsToCutenessInPuppiesConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInParrots, to: .cutenessInPuppies, amount: 1), 5.0)
    }

    func testCutenessInPuppiesToCutenessInParrotsConversion() {
        XCTAssertEqual(converter.convert(from: .cutenessInPuppies, to: .cutenessInParrots, amount: 1), 1/5.0)
    }

    func testMoscowSecondToRealSecondConversion() {
        XCTAssertEqual(converter.convert(from: .moscowSecond, to: .realSecond, amount: 1), 1/1000)
    }

    func testRealSecondToMoscowSecondConversion() {
        XCTAssertEqual(converter.convert(from: .realSecond, to: .moscowSecond, amount: 1), 1000.0)
    }

    // Example test method for a conversion case that is not supported
    func testUnsupportedConversion() {
        let originalValue: Double = 1.0
        let convertedValue = converter.convert(from: .parrots, to: .moscowSecond, amount: originalValue)
        XCTAssertEqual(convertedValue, originalValue, "Unsupported conversion should return the original value")
    }

    // MARK: - History Management Tests

    func testAddingRecordToHistory() {
        let preCount = converter.conversionHistory.count
        _ = converter.convert(from: .parrots, to: .boas, amount: 1)
        XCTAssertEqual(converter.conversionHistory.count, preCount + 1)
    }

    func testClearingHistory() {
        _ = converter.convert(from: .parrots, to: .boas, amount: 1)
        converter.clearHistory()
        XCTAssertTrue(converter.conversionHistory.isEmpty)
    }

    func testFindingRecordsInHistory() {
        _ = converter.convert(from: .parrots, to: .boas, amount: 1)
        let results = converter.findInHistory { $0.fromUnit == .parrots && $0.toUnit == .boas }
        XCTAssertFalse(results.isEmpty)
    }

}
