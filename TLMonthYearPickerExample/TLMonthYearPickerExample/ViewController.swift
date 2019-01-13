//
//  ViewController.swift
//  TLMonthYearPickerExample
//
//  Created by Thu Le on 12/22/16.
//  Copyright © 2016 lee5783. All rights reserved.
//

import UIKit
import TLMonthYearPicker

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TLMonthYearPickerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var _locale: Locale!
    internal var currentPickerIndex: Int = NSNotFound
    
    //data variable
    internal var selectedMonthYear: Date!
    internal var selectedYear: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPickerIndex = NSNotFound
        _locale = Locale(identifier: appLocaleIdentifier)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentPickerIndex != NSNotFound {
            return 3
        } else {
            return 2
        }
    }
    
    internal var minimumDate: Date {
        var components = Calendar.current.dateComponents([.month, .year], from: Date())
        components.year = components.year! - 5
        components.month = (components.month! - 6) % 12
        return Calendar.current.date(from: components)!
    }
    
    internal var maximumDate: Date {
        var components = Calendar.current.dateComponents([.month, .year], from: Date())
        components.year = components.year! + 5
        components.month = (components.month! + 6) % 12
        return Calendar.current.date(from: components)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.currentPickerIndex {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! PickerCell
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = _locale
            cell.monthYearPicker.calendar = calendar
            if self.currentPickerIndex == 1 {
                cell.monthYearPicker.monthYearPickerMode = .monthAndYear
            } else {
                cell.monthYearPicker.monthYearPickerMode = .year
            }
            cell.monthYearPicker.minimumDate = self.minimumDate
            cell.monthYearPicker.maximumDate = self.maximumDate
            cell.monthYearPicker.delegate = self
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            let dateFormater = DateFormatter()
            dateFormater.locale = self._locale
            if indexPath.row == 0 {
                //Month year cell
                if let date = self.selectedMonthYear {
                    dateFormater.dateFormat = "MMMM yyyy"
                    cell.lbName.text = dateFormater.string(from: date)
                } else {
                    cell.lbName.text = "Select Month and Year"
                }
            } else {
                if let date = self.selectedYear {
                    dateFormater.dateFormat = "yyyy"
                    cell.lbName.text = dateFormater.string(from: date)
                } else {
                    cell.lbName.text = "Select Year"
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentPickerIndex == NSNotFound {
            self.tableView.beginUpdates()
            self.showPickerCell(row: indexPath.row + 1)
            tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
        } else if self.currentPickerIndex != NSNotFound {
            if self.currentPickerIndex == indexPath.row  + 1 {
                self.tableView.beginUpdates()
                self.hidePickerCell()
                tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            } else {
                self.tableView.beginUpdates()
                let row = indexPath.row < self.currentPickerIndex ? indexPath.row + 1 : indexPath.row
                self.hidePickerCell()
                self.showPickerCell(row: row)
                tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    internal func hidePickerCell() {
        self.tableView.deleteRows(at: [
            IndexPath(row: self.currentPickerIndex, section: 0)
            ], with: .fade)
        self.currentPickerIndex = NSNotFound
    }
    
    internal func showPickerCell(row: Int) {
        self.currentPickerIndex = row
        self.tableView.insertRows(at: [
            IndexPath(row: self.currentPickerIndex, section: 0)
            ], with: .fade)
    }
    
    //MARK: - Picker delegate
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        if self.currentPickerIndex == NSNotFound {
            return
        }
        
        if self.currentPickerIndex == 1 {
            self.selectedMonthYear = date
        } else {
            self.selectedYear = date
        }
        
        self.tableView.reloadRows(at: [
            IndexPath(row: self.currentPickerIndex - 1, section: 0)
            ], with: .fade)
    }
}

class TextCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
}

class PickerCell: UITableViewCell {
    @IBOutlet weak var monthYearPicker: TLMonthYearPickerView!
}

