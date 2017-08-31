//
//  LocalesViewController.swift
//  TLMonthYearPickerExample
//
//  Created by Thu Le on 6/24/17.
//  Copyright © 2017 lee5783. All rights reserved.
//

import UIKit

class LocalesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var _locale: Locale!
    private var _allLocaleIds: [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _locale = Locale(identifier: appLocaleIdentifier)
        _allLocaleIds = [Locale.current.identifier, "vi_VN"]
        if Locale.current.identifier.compare("en_US") != .orderedSame {
            _allLocaleIds .insert("en_US", at: 0)
        }
        
        let index = _allLocaleIds.index(where: { appLocaleIdentifier.compare($0) == .orderedSame })
        if index != nil {
            tableView.selectRow(at: IndexPath(row: index!, section: 0), animated: false, scrollPosition: .none)
        }
    }

    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _allLocaleIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let identifier = _allLocaleIds[indexPath.row]
        let name = _locale.localizedString(forLanguageCode: identifier)!
        cell.textLabel?.text = "\(identifier) - \(name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        appLocaleIdentifier = _allLocaleIds[indexPath.row]
        _ = self.navigationController?.popViewController(animated: true)
    }
}
