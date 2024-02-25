//
//  ConvertionView.swift
//  FantasyUnitsConverter
//
//  Created by Roman Smirnov on 25.02.2024.
//

import UIKit

final class ConvertationViewController: UIViewController {
    var labelTitle = UILabel()
    var labelTitleFrom = UILabel()
    var labelSelectedFromUnit = UILabel()
    var textFieldAmount = UITextField()
    var labelTitleTo = UILabel()
    var labelSelectedToUnit = UILabel()
    var labelTitleResult = UILabel()
    var labelResult = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 2
        labelTitle.text = "Конвертер фантастических единиц измерения"
        labelTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        labelTitleFrom.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        labelTitleTo.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        labelTitleFrom.text = "Из:"
        labelSelectedFromUnit.text = "Нажми для выбора единицы измерения"
        textFieldAmount.placeholder = "Введи количество"
        labelTitleTo.text = "В:"
        labelSelectedToUnit.text = "Нажми для выбора единицы измерения"
        labelTitleResult.text = "Результат"
        labelResult.text = "Ожидается ввод..."


        textFieldAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldAmount.keyboardType = .numberPad

        let tapFrom = UITapGestureRecognizer(target: self, action: #selector(tapFrom))
        labelSelectedFromUnit.addGestureRecognizer(tapFrom)
        labelSelectedFromUnit.isUserInteractionEnabled = true
        let tapTo = UITapGestureRecognizer(target: self, action: #selector(tapTo))
        labelSelectedToUnit.addGestureRecognizer(tapTo)
        labelSelectedToUnit.isUserInteractionEnabled = true

        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        view.addSubview(labelTitle)
        view.addSubview(labelTitleFrom)
        view.addSubview(labelSelectedFromUnit)
        view.addSubview(textFieldAmount)
        view.addSubview(labelTitleTo)
        view.addSubview(labelSelectedToUnit)
        view.addSubview(labelTitleResult)
        view.addSubview(labelResult)
    }

    func setupConstraints() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitleFrom.translatesAutoresizingMaskIntoConstraints = false
        labelSelectedFromUnit.translatesAutoresizingMaskIntoConstraints = false
        textFieldAmount.translatesAutoresizingMaskIntoConstraints = false
        labelTitleTo.translatesAutoresizingMaskIntoConstraints = false
        labelSelectedToUnit.translatesAutoresizingMaskIntoConstraints = false
        labelTitleResult.translatesAutoresizingMaskIntoConstraints = false
        labelResult.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
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
        ])
    }

    @objc func tapFrom() {
        view.endEditing(true)
    }

    @objc func tapTo() {
        view.endEditing(true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
//        convert()
    }
}
