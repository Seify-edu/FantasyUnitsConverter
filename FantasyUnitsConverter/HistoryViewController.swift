//
//  HistoryViewController.swift
//  FantasyUnitsConverter
//
//  Created by Roman Smirnov on 26.02.2024.
//

import UIKit

final class HistoryViewController: UITableViewController {

    var conversionHistory: [ConversionEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversionHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let event = conversionHistory[indexPath.row]
        cell.textLabel?.text = event.description()
        cell.backgroundColor = .white
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = conversionHistory[indexPath.row]
        let alertTitle = event.description()
        let alertController = UIAlertController(title: "Детали конвертации", message: alertTitle, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    func update(history: [ConversionEvent]) {
        conversionHistory = history
        tableView.reloadData()
    }
}
