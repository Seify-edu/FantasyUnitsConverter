//
//  ConvertersutTests.swift
//  FantasyUnitsConverterTests
//
//  Created by andrew mayer on 21.02.24.
//

import XCTest
@testable import FantasyUnitsConverter

class ConverterViewControllerTests: XCTestCase {

    var sut: ConverterViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ConverterViewController()
        sut.conversionHistory = testData
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        ConverterController.shared.conversionHistory.removeAll()
        sut = nil
        try super.tearDownWithError()
    }

    func testUIElementsExistence() {
        XCTAssertNotNil(sut.segmentControl, "segmentControl does not exist")
        XCTAssertNotNil(sut.labelTitle, "labelTitle does not exist")
        XCTAssertNotNil(sut.labelTitleFrom, "labelTitleFrom does not exist")
        XCTAssertNotNil(sut.labelSelectedFromUnit, "labelSelectedFromUnit does not exist")
        XCTAssertNotNil(sut.textFieldAmount, "textFieldAmount does not exist")
        XCTAssertNotNil(sut.labelTitleTo, "labelTitleTo does not exist")
        XCTAssertNotNil(sut.labelSelectedToUnit, "labelSelectedToUnit does not exist")
        XCTAssertNotNil(sut.labelTitleResult, "labelTitleResult does not exist")
        XCTAssertNotNil(sut.labelResult, "labelResult does not exist")
        XCTAssertNotNil(sut.unitTableView, "unitTableView does not exist")
        XCTAssertNotNil(sut.historyTableView, "historyTableView does not exist")
    }

    func testUIElementsVisibilityWhenConverterSelected() {
        sut.segmentControl.selectedSegmentIndex = 0
        sut.segmentChanged(sut.segmentControl)

        XCTAssertFalse(sut.labelTitle.isHidden, "labelTitle should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelTitleFrom.isHidden, "labelTitleFrom should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelSelectedFromUnit.isHidden, "labelSelectedFromUnit should not be hidden when converter is selected")
        XCTAssertFalse(sut.textFieldAmount.isHidden, "textFieldAmount should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelTitleTo.isHidden, "labelTitleTo should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelSelectedToUnit.isHidden, "labelSelectedToUnit should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelTitleResult.isHidden, "labelTitleResult should not be hidden when converter is selected")
        XCTAssertFalse(sut.labelResult.isHidden, "labelResult should not be hidden when converter is selected")
        XCTAssertTrue(sut.unitTableView.isHidden, "unitTableView should be hidden when converter is selected")
        XCTAssertTrue(sut.historyTableView.isHidden, "historyTableView should be hidden when converter is selected")
    }

    func testUIElementsVisibilityWhenHistorySelected() {
        sut.segmentControl.selectedSegmentIndex = 1
        sut.segmentChanged(sut.segmentControl)

        XCTAssertTrue(sut.labelTitle.isHidden, "labelTitle should be hidden when history is selected")
        XCTAssertTrue(sut.labelTitleFrom.isHidden, "labelTitleFrom should be hidden when history is selected")
        XCTAssertTrue(sut.labelSelectedFromUnit.isHidden, "labelSelectedFromUnit should be hidden when history is selected")
        XCTAssertTrue(sut.textFieldAmount.isHidden, "textFieldAmount should be hidden when history is selected")
        XCTAssertTrue(sut.labelTitleTo.isHidden, "labelTitleTo should be hidden when history is selected")
        XCTAssertTrue(sut.labelSelectedToUnit.isHidden, "labelSelectedToUnit should be hidden when history is selected")
        XCTAssertTrue(sut.labelTitleResult.isHidden, "labelTitleResult should be hidden when history is selected")
        XCTAssertTrue(sut.labelResult.isHidden, "labelResult should be hidden when history is selected")
        XCTAssertTrue(sut.unitTableView.isHidden, "unitTableView should be hidden when history is selected")
        XCTAssertFalse(sut.historyTableView.isHidden, "historyTableView should not be hidden when history is selected")
    }

    func testSegmentControlInitialValue() {
        XCTAssertEqual(sut.segmentControl.selectedSegmentIndex, 0, "Segment control should start with the converter segment selected.")
    }

    func testInitialLabelsText() {
        XCTAssertEqual(sut.labelTitle.text, "Конвертер фантастических единиц измерения")
        XCTAssertEqual(sut.labelTitleFrom.text, "Из:")
        XCTAssertEqual(sut.labelSelectedFromUnit.text, "Нажми для выбора единицы измерения")
        XCTAssertEqual(sut.labelTitleTo.text, "В:")
        XCTAssertEqual(sut.labelSelectedToUnit.text, "Нажми для выбора единицы измерения")
        XCTAssertEqual(sut.labelTitleResult.text, "Результат")
        XCTAssertEqual(sut.labelResult.text, "Ожидается ввод...")
    }

    func testTextFieldConfiguration() {
        XCTAssertEqual(sut.textFieldAmount.keyboardType, .numberPad)
    }

    func testTableViewsDelegation() {
        XCTAssertTrue(sut.unitTableView.delegate === sut)
        XCTAssertTrue(sut.unitTableView.dataSource === sut)
        XCTAssertTrue(sut.historyTableView.delegate === sut)
        XCTAssertTrue(sut.historyTableView.dataSource === sut)
    }

    func testNumberOfRowsInUnitTableView() {
        let expectedRows = FantasticUnits.allCases.count
        XCTAssertEqual(sut.tableView(sut.unitTableView, numberOfRowsInSection: 0), expectedRows)
    }

    func testNumberOfRowsInHistoryTableView() {
        sut.segmentControl.selectedSegmentIndex = 1 // Switch to History
        sut.segmentChanged(sut.segmentControl)
        let event = ConversionEvent(fromUnit: .parrots, toUnit: .boas, outputValue: 1.0, timestamp: Date())
        sut.conversionHistory = [event]
        XCTAssertEqual(sut.tableView(sut.historyTableView, numberOfRowsInSection: 0), 1)
    }

    func testCellForRowInUnitTableView() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.unitTableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.textLabel?.text, FantasticUnits.allCases[0].title)
    }

    func testCellForRowInHistoryTableView() {
        sut.isShowingConverter = false
        let indexPath = IndexPath(row: 0, section: 0)
        let event = ConversionEvent(fromUnit: .parrots, toUnit: .boas, outputValue: 1.0, timestamp: Date())
        sut.conversionHistory = [event]
        let cell = sut.tableView(sut.historyTableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.textLabel?.text, event.description())
    }

    func testSelectingFromUnit() {
        sut.isFirstUnitSelecting = true
        sut.tableView(sut.unitTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(sut.selectedFromUnit, FantasticUnits.allCases[0])
    }

    func testSelectingToUnit() {
        sut.isFirstUnitSelecting = false
        sut.isSecondUnitSelecting = true
        sut.units = FantasticUnits.allCases
        sut.tableView(sut.unitTableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        XCTAssertEqual(sut.selectedToUnit, FantasticUnits.allCases[1])
    }

    func testSegmentSwitchConverter() {
        sut.segmentControl.selectedSegmentIndex = 0
        sut.segmentChanged(sut.segmentControl)

        XCTAssertTrue(sut.isShowingConverter)

        XCTAssertFalse(sut.labelTitle.isHidden)
        XCTAssertFalse(sut.labelTitleFrom.isHidden)
        XCTAssertFalse(sut.labelSelectedFromUnit.isHidden)
        XCTAssertFalse(sut.textFieldAmount.isHidden)
        XCTAssertFalse(sut.labelTitleTo.isHidden)
        XCTAssertFalse(sut.labelSelectedToUnit.isHidden)
        XCTAssertFalse(sut.labelTitleResult.isHidden)
        XCTAssertFalse(sut.labelResult.isHidden)
        XCTAssertTrue(sut.unitTableView.isHidden)
        XCTAssertTrue(sut.historyTableView.isHidden)
    }

    func testSegmentSwitchToHistory() {
        sut.segmentControl.selectedSegmentIndex = 1
        sut.segmentChanged(sut.segmentControl)

        XCTAssertFalse(sut.isShowingConverter)

        XCTAssertTrue(sut.labelTitle.isHidden)
        XCTAssertTrue(sut.labelTitleFrom.isHidden)
        XCTAssertTrue(sut.labelSelectedFromUnit.isHidden)
        XCTAssertTrue(sut.textFieldAmount.isHidden)
        XCTAssertTrue(sut.labelTitleTo.isHidden)
        XCTAssertTrue(sut.labelSelectedToUnit.isHidden)
        XCTAssertTrue(sut.labelTitleResult.isHidden)
        XCTAssertTrue(sut.labelResult.isHidden)
        XCTAssertTrue(sut.unitTableView.isHidden)
        XCTAssertFalse(sut.historyTableView.isHidden)
    }

    func testConversionFlow() {
        sut.selectedFromUnit = .parrots
        sut.selectedToUnit = .boas
        sut.textFieldAmount.text = "100"
        sut.convert()
        XCTAssertEqual(sut.labelResult.text, "Результат: 2.6315789473684212")
    }

    func testTextFieldEditingTriggersConversion() {
        sut.selectedFromUnit = .parrots
        sut.selectedToUnit = .boas
        sut.textFieldAmount.text = "100"
        sut.textFieldDidChange(sut.textFieldAmount)
        XCTAssertNotEqual(sut.labelResult.text, "Ожидается ввод...")
        XCTAssertEqual(sut.labelResult.text, "Результат: 2.6315789473684212")
    }

    func testCellBackgroundColorForAlternation() {
        sut.isShowingConverter = true // Ensure we are testing the converter part
        let firstCell = sut.tableView(sut.unitTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let secondCell = sut.tableView(sut.unitTableView, cellForRowAt: IndexPath(row: 1, section: 0))

        // Assuming alternating background colors are set
        XCTAssertNotEqual(firstCell.backgroundColor, secondCell.backgroundColor, "Adjacent cells should have different background colors for alternation")
    }
}

let testData: [ConversionEvent] = [
    ConversionEvent(fromUnit: .parrots, toUnit: .boas, outputValue: 1.0, timestamp: Date()),
    ConversionEvent(fromUnit: .boas, toUnit: .parrots, outputValue: 38.0, timestamp: Date().addingTimeInterval(-86400)), // One day ago
]
