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

    lazy var convertationViewController = {
        let controller = ConvertationViewController()
        controller.delegate = self

        return controller
    }()

    let historyViewController = HistoryViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(convertationViewController)
        addChild(historyViewController)

        addSubviews()
        setupConstraints()

        ConverterController.shared.view = self
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        updateUI()
    }

    func addSubviews() {
        view.addSubview(convertationViewController.view)
        view.addSubview(historyViewController.view)
        view.addSubview(segmentControl)
    }

    func setupConstraints() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        convertationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        historyViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            convertationViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            convertationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            convertationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            convertationViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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
        } else if !isShowingConverter {
            convertationViewController.view.isHidden = true
            historyViewController.view.isHidden = false
            historyViewController.update(history: ConverterController.shared.conversionHistory)
        }
    }
}

//MARK: - ConvertationViewControllerDelegate

extension ConverterViewController: ConvertationViewControllerDelegate {
    func didTapFrom() {
        let controller = UnitSelectionViewController()
        controller.units = FantasticUnits.allCases
        controller.onSelection = { [weak self] unit in
            self?.convertationViewController.show(to: "Нажми для выбора единицы измерения")
            self?.selectedFromUnit = unit
            self?.selectedToUnit = nil
            self?.convertationViewController.show(from: unit.title)
            self?.dismiss(animated: true)
        }
        present(controller, animated: true)
    }
    
    func didTapTo() {
        let units = FantasticUnits.possibleConversions(for: selectedFromUnit!)
        let controller = UnitSelectionViewController()
        controller.units = units
        controller.onSelection = {[weak self] unit in
            self?.selectedToUnit = unit
            self?.convertationViewController.show(to: unit.title)
            self?.dismiss(animated: true)
        }
        present(controller, animated: true)
    }

    func didUpdateAmount() {
        convert()
    }
}
