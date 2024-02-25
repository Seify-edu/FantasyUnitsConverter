//
//  ViewController.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

class ConverterViewController: UIViewController {

    var segmentControl = UISegmentedControl(items: ["Конвертер", "История"])

    var selectedFromUnit: FantasticUnits? = nil
    var selectedToUnit: FantasticUnits? = nil

    var isFirstUnitSelecting: Bool = false
    var isSecondUnitSelecting: Bool = false

    lazy var convertationViewController = {
        let controller = ConvertationViewController()
        controller.delegate = self

        return controller
    }()

    let historyViewController = HistoryViewController()
    lazy var unitSelectionViewController = {
        let controller = UnitSelectionViewController()
        controller.delegate = self

        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(convertationViewController)
        addChild(historyViewController)
        addChild(unitSelectionViewController)

        addSubviews()
        setupConstraints()

        ConverterController.shared.view = self
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        unitSelectionViewController.view.isHidden = true

        updateUI()
    }

    func addSubviews() {
        view.addSubview(convertationViewController.view)
        view.addSubview(historyViewController.view)
        view.addSubview(segmentControl)
        view.addSubview(unitSelectionViewController.view)
    }

    func setupConstraints() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        convertationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        unitSelectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        historyViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            convertationViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            convertationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            convertationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            convertationViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            unitSelectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            unitSelectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unitSelectionViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            unitSelectionViewController.view.heightAnchor.constraint(equalToConstant: 300),

            historyViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            historyViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            historyViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }

    func convert() {
        guard let selectedFromUnit, let selectedToUnit else { return }
        let result = ConverterController.shared.convert(from: selectedFromUnit, to: selectedToUnit, amount: convertationViewController.amount)
        convertationViewController.show(result: result)
    }

    func updateUI() {
        switchState(isShowingConverter: true)
        segmentControl.selectedSegmentIndex = 0
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let isShowingConverter = sender.selectedSegmentIndex == 0
        switchState(isShowingConverter: isShowingConverter)
    }

    func switchState(isShowingConverter: Bool) {
        if isShowingConverter {
            convertationViewController.view.isHidden = false
            historyViewController.view.isHidden = true
            unitSelectionViewController.view.isHidden = true
        } else if !isShowingConverter {
            convertationViewController.view.isHidden = true
            historyViewController.view.isHidden = false
            historyViewController.update(history: ConverterController.shared.conversionHistory)
            unitSelectionViewController.view.isHidden = true
        }
    }
}

//MARK: - ConvertationViewControllerDelegate

extension ConverterViewController: ConvertationViewControllerDelegate {
    func didTapFrom() {
        let units = FantasticUnits.allCases
        unitSelectionViewController.update(units: units)
        isFirstUnitSelecting = true
        isSecondUnitSelecting = false
        unitSelectionViewController.view.isHidden = false
    }
    
    func didTapTo() {
        isFirstUnitSelecting = false
        isSecondUnitSelecting = true
        unitSelectionViewController.view.isHidden = false
    }

    func didUpdateAmount() {
        convert()
    }
}

extension ConverterViewController: UnitSelectionViewControllerDelegate {
    func didSelect(unit: FantasticUnits) {
        if isFirstUnitSelecting {
            convertationViewController.show(to: "Нажми для выбора единицы измерения")
            selectedFromUnit = unit
            selectedToUnit = nil
            convertationViewController.show(from: unit.title)
            let units = FantasticUnits.possibleConversions(for: selectedFromUnit!)
            unitSelectionViewController.update(units: units)
        } else if isSecondUnitSelecting {
            selectedToUnit = unit
            convertationViewController.show(to: unit.title)
        }

        unitSelectionViewController.view.isHidden = true
        convert()
    }
}
