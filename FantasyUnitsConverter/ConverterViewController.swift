//
//  ViewController.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

class ConverterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var segmentControl = UISegmentedControl(items: ["Конвертер", "История"])
    var unitTableView = UITableView()
    var historyTableView = UITableView()

    var units = FantasticUnits.allCases
    var selectedFromUnit: FantasticUnits? = nil
    var selectedToUnit: FantasticUnits? = nil

    var conversionHistory: [ConversionEvent] = []

    var isShowingConverter: Bool = true
    var isFirstUnitSelecting: Bool = false
    var isSecondUnitSelecting: Bool = false

    lazy var convertationViewController = {
        let controller = ConvertationViewController()
        controller.delegate = self

        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(convertationViewController)

        addSubviews()
        setupConstraints()

        ConverterController.shared.view = self
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        unitTableView.delegate = self
        unitTableView.dataSource = self
        unitTableView.isHidden = true
        unitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        updateUI()
    }

    func addSubviews() {
        view.addSubview(convertationViewController.view)
        view.addSubview(historyTableView)
        view.addSubview(segmentControl)
        view.addSubview(unitTableView)
    }

    func setupConstraints() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        convertationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        unitTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            convertationViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            convertationViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            convertationViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            convertationViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            unitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            unitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            unitTableView.heightAnchor.constraint(equalToConstant: 300),

            historyTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            historyTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingConverter {
            return units.count
        } else if !isShowingConverter {
            return conversionHistory.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingConverter {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = units[indexPath.row].title
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .gray.withAlphaComponent(0.1)
            } else if indexPath.row % 2 == 1 {
                cell.backgroundColor = .gray.withAlphaComponent(0.05)
            }
            return cell
        } else if !isShowingConverter {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let event = conversionHistory[indexPath.row]
            cell.textLabel?.text = event.description()
            cell.backgroundColor = .white
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingConverter {
            if isFirstUnitSelecting {
                convertationViewController.show(to: "Нажми для выбора единицы измерения")
                selectedFromUnit = units[indexPath.row]
                selectedToUnit = nil
                convertationViewController.show(from: units[indexPath.row].title)
                units = FantasticUnits.possibleConversions(for: selectedFromUnit!)
                tableView.reloadData()
            } else if isSecondUnitSelecting {
                selectedToUnit = units[indexPath.row]
                convertationViewController.show(to: units[indexPath.row].title)
            }

            unitTableView.isHidden = true
            convert()
        } else if !isShowingConverter {
            tableView.deselectRow(at: indexPath, animated: true)
            let event = conversionHistory[indexPath.row]
            let alertTitle = event.description()
            let alertController = UIAlertController(title: "Детали конвертации", message: alertTitle, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }

    func convert() {
        guard let selectedFromUnit, let selectedToUnit else { return }
        let result = ConverterController.shared.convert(from: selectedFromUnit, to: selectedToUnit, amount: convertationViewController.amount)
        convertationViewController.show(result: result)
    }

    func updateUI() {
        switchState()
        segmentControl.selectedSegmentIndex = 0
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        isShowingConverter = sender.selectedSegmentIndex == 0
        switchState()
    }

    func switchState() {
        if isShowingConverter {
            convertationViewController.view.isHidden = false

            unitTableView.isHidden = true
            historyTableView.isHidden = true
            unitTableView.reloadData()
        } else if !isShowingConverter {
            conversionHistory = ConverterController.shared.conversionHistory

            convertationViewController.view.isHidden = true

            unitTableView.isHidden = true
            historyTableView.isHidden = false
            historyTableView.reloadData()
        }
    }
}

//MARK: - ConvertationViewControllerDelegate

extension ConverterViewController: ConvertationViewControllerDelegate {
    func didTapFrom() {
        units = FantasticUnits.allCases
        unitTableView.reloadData()
        isFirstUnitSelecting = true
        isSecondUnitSelecting = false
        unitTableView.isHidden = false
    }
    
    func didTapTo() {
        isFirstUnitSelecting = false
        isSecondUnitSelecting = true
        unitTableView.isHidden = false
    }

    func didUpdateAmount() {
        convert()
    }
}
