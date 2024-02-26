//
//  UnitSelectionViewController.swift
//  FantasyUnitsConverter
//
//  Created by Roman Smirnov on 26.02.2024.
//

import UIKit

final class UnitSelectionViewController: UITableViewController {
    var units = FantasticUnits.allCases
    var onSelection: ((FantasticUnits) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        units.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = units[indexPath.row].title
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .gray.withAlphaComponent(0.1)
        } else if indexPath.row % 2 == 1 {
            cell.backgroundColor = .gray.withAlphaComponent(0.05)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUnit = units[indexPath.row]
        onSelection?(selectedUnit)
    }

    func update(units: [FantasticUnits]) {
        self.units = units

        tableView.reloadData()
    }
}

