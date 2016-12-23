//
//  TLMonthYearPickerView.swift
//  TLMonthYearPicker
//
//  Created by lee5783 on 12/22/16.
//  Copyright © 2016 lee5783. All rights reserved.
//

import UIKit

/// enum MonthYearPickerMode
///
/// - monthAndYear: Show month and year components
/// - year: Show year only
public enum MonthYearPickerMode: Int {
    case monthAndYear = 0
    case year = 1
}

/// Maximum year constant
fileprivate let kMaximumYears = 5000
/// Minimum year constant
fileprivate let kMinimumYears = 1

public protocol TLMonthYearPickerDelegate: NSObjectProtocol {
    /// Delegate: notify picker date changed
    ///
    /// - Parameters:
    ///   - picker: return picker instant
    ///   - date: return picker date value
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date)
}

public class TLMonthYearPickerView: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Set picker mode: monthAndYear or year only
    fileprivate var _mode: MonthYearPickerMode = .monthAndYear
    public var monthYearPickerMode: MonthYearPickerMode {
        get {
            return self._mode
        }
        set(value) {
            self._mode = value
            self._picker?.reloadAllComponents()
            self.setDate(date: self.date, animated: false)
        }
    }
    
    /// Locale value, default is device locale
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
            self._calendar.locale = value
        }
    }
    
    /// Calendar value, default is device calendar
    fileprivate var _calendar: Calendar!
    public var calendar: Calendar! {
        get {
            if self._calendar != nil {
                return self.calendar
            } else {
                var calendar = Calendar.current
                calendar.locale = self.locale
                return calendar
            }
        }
        
        set(value) {
            self._calendar = value
        }
    }
    
    
    /// Picker text color, default is black color
    public var textColor: UIColor = UIColor.black {
        didSet(value) {
            self._picker?.reloadAllComponents()
        }
    }
    
    
    /// Picker font, default is system font with size 16
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet(value) {
            self._picker?.reloadAllComponents()
        }
    }
    
    /// Get/Set Picker background color
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set(value) {
            super.backgroundColor = value
            self._picker?.backgroundColor = value
        }
    }
    
    /// Current picker value
    public var date: Date!
    
    /// Delegate
    public weak var delegate: TLMonthYearPickerDelegate?
    
    /// Maximum date
    fileprivate var _minimumDate: Date?
    public var minimumDate: Date? {
        get {
            return self._minimumDate
        }
        
        set(value) {
            self._minimumDate = value
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
    
    /// Mimimum date
    fileprivate var _maximumDate: Date?
    public var maximumDate: Date? {
        get {
            return self._maximumDate
        }
        
        set(value) {
            self._maximumDate = value
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
    
    /// UIPicker
    fileprivate var _picker: UIPickerView!
    
    /// month year array values
    fileprivate var _months: [String] = []
    fileprivate var _years: [String] = []
    
    /// Store caculated value of minimum year-month and maximum year-month
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
    
    
    /// Initial view 
    /// Setup Picker and Picker data
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
    
    
    /// Setup picker data
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
    
    
    /// Set picker date to UI
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setDate(date: self.date, animated: false)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self._picker?.frame = self.bounds
    }
    
    //MARK: - Public function
    
    /// Set date to picker
    ///
    /// - Parameters:
    ///   - date: the date user choose
    ///   - animated: display UI animate or not
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
    }
    
    //MARK: - Implement UIPickerViewDataSource, UIPickerViewDelegate

    /// - Parameters:
    /// - Parameter pickerView
    /// - Returns: return 2 if pickerMode is monthAndYear, otherwise return 1
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.monthYearPickerMode == .year ? 1 : 2
    }
    
    
    /// - Parameters:
    ///   - pickerView
    ///   - component
    /// - Returns: return number of row
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

    /// - Parameters:
    ///   - pickerView
    ///   - row
    ///   - component
    /// - Returns: display string of specific row in specific component
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let isSelectYear = self.monthYearPickerMode == .year || component == 1
        var shouldDisable = false
        
        if isSelectYear {
            let year = row + kMinimumYears
            if (self._maximumDate != nil && year > _maximumYear) || (self._minimumDate != nil && year < _minimumYear)
            {
                shouldDisable = true
            }
        } else {
            let month = row + 1
            let components = self.calendar.dateComponents([.year], from: self.date)
            let year = components.year!
            
            if (self._maximumDate != nil && year > _maximumYear)
                || (year == _maximumYear && month > _maximumMonth)
                || (self._minimumDate != nil && year < _minimumYear)
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
    
    /// - Parameters:
    ///   - pickerView
    ///   - row
    ///   - component
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let date = self.dateFromSelection() {
            self.date = date
            
            if let minimumDate = self._minimumDate {
                if minimumDate.compare(date) == .orderedDescending {
                    self.setDate(date: minimumDate, animated: true)
                }
            }
            
            if let maximumDate = self._maximumDate {
                if maximumDate.compare(date) == .orderedAscending {
                    self.setDate(date: maximumDate, animated: true)
                }
            }
            
            self.delegate?.monthYearPickerView(picker: self, didSelectDate: date)
            
            if self.monthYearPickerMode == .monthAndYear {
                self._picker.reloadComponent(0)
            }
        }
    }
    
    
    /// Compare only month and year value
    ///
    /// - Parameters:
    ///   - date1: first date you want to compare
    ///   - date2: second date you want to compare
    /// - Returns: ComparisonResult
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
    
    /// Caculate date of current picker
    ///
    /// - Returns: Date
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
        components.timeZone = TimeZone(secondsFromGMT: 0)
        return self.calendar.date(from: components)
    }
}
