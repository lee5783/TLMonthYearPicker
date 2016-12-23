//
//  TLMonthYearPickerView.swift
//  TLMonthYearPicker
//
//  Created by lee5783 on 12/22/16.
//  Copyright © 2016 lee5783. All rights reserved.
//

import UIKit

public enum MonthYearPickerMode: Int {
    case monthAndYear = 0
    case year = 1
}

fileprivate let kMaximumYears = 5000
fileprivate let kMinimumYears = 1

public protocol TLMonthYearPickerDelegate: NSObjectProtocol {
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date)
}

public class TLMonthYearPickerView: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public var monthYearPickerMode = MonthYearPickerMode.monthAndYear {
        didSet(value) {
            self._picker?.reloadAllComponents()
            self.setDate(date: self.date, animated: false)
        }
    }
    
    fileprivate var _locale: Locale?
    var locale: Locale! {
        get {
            if self._locale != nil {
                return self._locale!
            } else {
                return Locale.current
            }
        }
        
        set(value) {
            self._locale = value
        }
    }
    
    fileprivate var _calendar: Calendar!
    public var calendar: Calendar! {
        get {
            if self._calendar != nil {
                return self.calendar
            } else {
                return Calendar.current
            }
        }
        
        set(value) {
            self._calendar = value
        }
    }
    
    public var textColor: UIColor = UIColor.black {
        didSet(value) {
            self._picker?.reloadAllComponents()
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet(value) {
            self._picker?.reloadAllComponents()
        }
    }
    
    public var date: Date!
    
    public weak var delegate: TLMonthYearPickerDelegate?
    
    public var minimumDate: Date? {
        didSet(value) {
            if let date = value {
                let components = self.calendar.dateComponents([.year, .month], from: date)
                _minimumYear = components.year!
                _minimumMonth = components.month!
            } else {
                _minimumYear = -1
                _minimumMonth = -1
            }
            
            self._picker?.reloadAllComponents()
        }
    }
    public var maximumDate: Date? {
        didSet(value) {
            if let date = value {
                let components = self.calendar.dateComponents([.year, .month], from: date)
                _maximumYear = components.year!
                _maximumMonth = components.month!
            } else {
                _maximumYear = -1
                _maximumMonth = -1
            }
            
            self._picker?.reloadAllComponents()
        }
    }
    
    //MARK: - Internal variables
    fileprivate var _picker: UIPickerView!
    
    fileprivate var _months: [String] = []
    fileprivate var _years: [String] = []
    
    fileprivate var _minimumYear = -1
    fileprivate var _maximumYear = -1
    fileprivate var _minimumMonth = -1
    fileprivate var _maximumMonth = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    internal func initView() {
        self._picker = UIPickerView(frame: self.bounds)
        self._picker.showsSelectionIndicator = true
        self._picker.delegate = self
        self._picker.dataSource = self
        self._picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._picker.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self._picker)
        self.clipsToBounds = true
        
        self.initPickerData()
        self.date = Date()
        self._picker.reloadAllComponents()
    }
    
    internal func initPickerData() {
        //list of month
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.locale == nil ? Locale.current : self.locale!
        self._months = dateFormatter.monthSymbols
        
        dateFormatter.dateFormat = "yyyy"
        var components = DateComponents()
        
        for year in kMinimumYears...kMaximumYears {
            components.year = year
            if let date = self.calendar.date(from: components) {
                self._years.append(dateFormatter.string(from: date))
            }
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.setDate(date: self.date, animated: false)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self._picker?.frame = self.bounds
    }
    
    //MARK: - Public function
    func setDate(date: Date, animated: Bool) {
        // Extract the month and year from the current date value
        let components = self.calendar.dateComponents([.year, .month], from: date)
        
        let month = components.month!
        let year = components.year!
        
        self.date = date
        if self.monthYearPickerMode == .year {
            self._picker.selectRow(year - kMinimumYears, inComponent: 0, animated: animated)
        } else {
            self._picker.selectRow(year - kMinimumYears, inComponent: 1, animated: animated)
            self._picker.selectRow(month - 1, inComponent: 0, animated: animated)
        }
        self.delegate?.monthYearPickerView(picker: self, didSelectDate: date)
    }
    
    //MARK: - Implement UIPickerViewDataSource, UIPickerViewDelegate
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.monthYearPickerMode == .year ? 1 : 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.monthYearPickerMode == .year {
            return self._years.count
        } else {
            if component == 0 {
                return self._months.count
            } else {
                return self._years.count
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let isSelectYear = self.monthYearPickerMode == .year || component == 1
        var shouldDisable = false
        
        if isSelectYear {
            let year = row + kMinimumYears
            if (self.maximumDate != nil && year > _maximumYear) || (self.minimumDate != nil && year < _minimumYear)
            {
                shouldDisable = true
            }
        } else {
            let month = row + 1
            let components = self.calendar.dateComponents([.year], from: self.date)
            let year = components.year!
            
            if (self.maximumDate != nil && year > _maximumYear)
                || (year == _maximumYear && month > _maximumMonth)
                || (self.minimumDate != nil && year < _minimumYear)
                || (year == _minimumYear && month < _minimumMonth) {
                shouldDisable = true
            }
        }
        
        var text = ""
        if self.monthYearPickerMode == .year {
            text = self._years[row]
        } else {
            if component == 0 {
                text = self._months[row]
            } else {
                text = self._years[row]
            }
        }
        
        var color = self.textColor
        if shouldDisable {
            color = color.withAlphaComponent(0.5)
        }
        
        return NSAttributedString(string: text, attributes: [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: color
            ])
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let date = self.dateFromSelection() {
            self.date = date
            
            if let minimumDate = self.minimumDate {
                if minimumDate.compare(date) == .orderedDescending {
                    self.setDate(date: minimumDate, animated: true)
                }
            } else if let maximumDate = self.maximumDate {
                if maximumDate.compare(date) == .orderedAscending {
                    self.setDate(date: maximumDate, animated: true)
                }
            } else {
                self.setDate(date: date, animated: false)
            }
            
            if self.monthYearPickerMode == .monthAndYear {
                self._picker.reloadComponent(0)
            }
        }
    }
    
    fileprivate func compareMonthAndYear(date1: Date, date2: Date) -> ComparisonResult {
        let components1 = self.calendar.dateComponents([.year, .month], from: date1)
        let components2 = self.calendar.dateComponents([.year, .month], from: date2)
        if let date1Compare = self.calendar.date(from: components1),
            let date2Compare = self.calendar.date(from: components2) {
            return date1Compare.compare(date2Compare)
        } else {
            return date1.compare(date2)
        }
    }
    
    fileprivate func dateFromSelection() -> Date? {
        var month = 1
        var year = 1
        if self.monthYearPickerMode == .year {
            year = self._picker.selectedRow(inComponent: 0) + kMinimumYears
        } else {
            month = self._picker.selectedRow(inComponent: 0) + 1
            year = self._picker.selectedRow(inComponent: 1) + kMinimumYears
        }
        
        var components = DateComponents()
        components.month = month
        components.year = year
        components.day = 1
        
        return self.calendar.date(from: components)
    }
}
