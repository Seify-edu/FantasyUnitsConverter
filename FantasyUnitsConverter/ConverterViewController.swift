//
//  ViewController.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

class ConverterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var segmentControl = UISegmentedControl(items: ["Конвертер", "История"])
    var labelTitle = UILabel()
    var labelTitleFrom = UILabel()
    var labelSelectedFromUnit = UILabel()
    var textFieldAmount = UITextField()
    var labelTitleTo = UILabel()
    var labelSelectedToUnit = UILabel()
    var labelTitleResult = UILabel()
    var labelResult = UILabel()
    var unitTableView = UITableView()
    var historyTableView = UITableView()

    var units = FantasticUnits.allCases
    var selectedFromUnit: FantasticUnits? = nil
    var selectedToUnit: FantasticUnits? = nil

    var conversionHistory: [ConversionEvent] = []

    var isShowingConverter: Bool = true
    var isFirstUnitSelecting: Bool = false
    var isSecondUnitSelecting: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        ConverterController.shared.view = self
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 2
        labelTitle.text = "Конвертер фантастических единиц измерения"
        labelTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        labelTitleFrom.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        labelTitleTo.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        unitTableView.delegate = self
        unitTableView.dataSource = self
        unitTableView.isHidden = true
        unitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        textFieldAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldAmount.keyboardType = .numberPad
        let tapFrom = UITapGestureRecognizer(target: self, action: #selector(tapFrom))
        labelSelectedFromUnit.addGestureRecognizer(tapFrom)
        labelSelectedFromUnit.isUserInteractionEnabled = true
        let tapTo = UITapGestureRecognizer(target: self, action: #selector(tapTo))
        labelSelectedToUnit.addGestureRecognizer(tapTo)
        labelSelectedToUnit.isUserInteractionEnabled = true
        updateUI()
    }

    func addSubviews() {
        view.addSubview(historyTableView)
        view.addSubview(segmentControl)
        view.addSubview(labelTitle)
        view.addSubview(labelTitleFrom)
        view.addSubview(labelSelectedFromUnit)
        view.addSubview(textFieldAmount)
        view.addSubview(labelTitleTo)
        view.addSubview(labelSelectedToUnit)
        view.addSubview(labelTitleResult)
        view.addSubview(labelResult)
        view.addSubview(unitTableView)
    }

    func setupConstraints() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitleFrom.translatesAutoresizingMaskIntoConstraints = false
        labelSelectedFromUnit.translatesAutoresizingMaskIntoConstraints = false
        textFieldAmount.translatesAutoresizingMaskIntoConstraints = false
        labelTitleTo.translatesAutoresizingMaskIntoConstraints = false
        labelSelectedToUnit.translatesAutoresizingMaskIntoConstraints = false
        labelTitleResult.translatesAutoresizingMaskIntoConstraints = false
        labelResult.translatesAutoresizingMaskIntoConstraints = false
        unitTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            labelTitle.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            labelTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelTitleFrom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            labelTitleFrom.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelTitleFrom.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelSelectedFromUnit.topAnchor.constraint(equalTo: labelTitleFrom.bottomAnchor, constant: 10),
            labelSelectedFromUnit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelSelectedFromUnit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textFieldAmount.topAnchor.constraint(equalTo: labelSelectedFromUnit.bottomAnchor, constant: 20),
            textFieldAmount.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textFieldAmount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelTitleTo.topAnchor.constraint(equalTo: textFieldAmount.bottomAnchor, constant: 50),
            labelTitleTo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelTitleTo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelSelectedToUnit.topAnchor.constraint(equalTo: labelTitleTo.bottomAnchor, constant: 10),
            labelSelectedToUnit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelSelectedToUnit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelTitleResult.topAnchor.constraint(equalTo: labelSelectedToUnit.bottomAnchor, constant: 50),
            labelTitleResult.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelTitleResult.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            labelResult.topAnchor.constraint(equalTo: labelTitleResult.bottomAnchor, constant: 20),
            labelResult.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            labelResult.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
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

    @objc func textFieldDidChange(_ textField: UITextField) {
        convert()
    }

    @objc func tapFrom() {
        // Bad practice: mixing view logic with model logic, no separation of concerns
        view.endEditing(true)
        units = FantasticUnits.allCases
        unitTableView.reloadData()
        isFirstUnitSelecting = true
        isSecondUnitSelecting = false
        unitTableView.isHidden = false
    }

    @objc func tapTo() {
        view.endEditing(true)
        isFirstUnitSelecting = false
        isSecondUnitSelecting = true
        unitTableView.isHidden = false
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
                labelSelectedToUnit.text = "Нажми для выбора единицы измерения"
                selectedFromUnit = units[indexPath.row]
                selectedToUnit = nil
                labelSelectedFromUnit.text = units[indexPath.row].title
                units = FantasticUnits.possibleConversions(for: selectedFromUnit!)
                tableView.reloadData()
            } else if isSecondUnitSelecting {
                selectedToUnit = units[indexPath.row]
                labelSelectedToUnit.text = units[indexPath.row].title
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
        let result = ConverterController.shared.convert(from: selectedFromUnit, to: selectedToUnit, amount: Double(textFieldAmount.text ?? "0") ?? 0.0)
        labelResult.text = "Результат: \(result)"
    }

    func updateUI() {
        switchState()
        segmentControl.selectedSegmentIndex = 0
        labelTitleFrom.text = "Из:"
        labelSelectedFromUnit.text = "Нажми для выбора единицы измерения"
        textFieldAmount.placeholder = "Введи количество"
        labelTitleTo.text = "В:"
        labelSelectedToUnit.text = "Нажми для выбора единицы измерения"
        labelTitleResult.text = "Результат"
        labelResult.text = "Ожидается ввод..."
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        isShowingConverter = sender.selectedSegmentIndex == 0
        switchState()
    }

    func switchState() {
        if isShowingConverter {
            labelTitle.isHidden = false
            labelTitleFrom.isHidden = false
            labelSelectedFromUnit.isHidden = false
            textFieldAmount.isHidden = false
            labelTitleTo.isHidden = false
            labelSelectedToUnit.isHidden = false
            labelTitleResult.isHidden = false
            labelResult.isHidden = false
            unitTableView.isHidden = true
            historyTableView.isHidden = true
            unitTableView.reloadData()
        } else if !isShowingConverter {
            conversionHistory = ConverterController.shared.conversionHistory
            labelTitle.isHidden = true
            labelTitleFrom.isHidden = true
            labelSelectedFromUnit.isHidden = true
            textFieldAmount.isHidden = true
            labelTitleTo.isHidden = true
            labelSelectedToUnit.isHidden = true
            labelTitleResult.isHidden = true
            labelResult.isHidden = true
            unitTableView.isHidden = true
            historyTableView.isHidden = false
            historyTableView.reloadData()
        }
    }
}
