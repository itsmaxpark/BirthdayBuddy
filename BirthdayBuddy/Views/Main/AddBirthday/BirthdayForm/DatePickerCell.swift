//
//  DatePickerCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/7/22.
//

import UIKit

protocol CustomPickerViewDelegate: AnyObject {
    func pickerViewSetDate(date: Date)
}

class DatePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    static let identifier = "DatePickerCell"
    var customDelegate: CustomPickerViewDelegate?
    var months = Calendar.current.monthSymbols
    var initialDate: Date? {
        didSet{
            
        }
    }
    var showYear: Bool = false {
        didSet {
            datePicker.reloadAllComponents()
            print("showYear is \(showYear)")
        }
    }
    
    private let datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(datePicker)
        datePicker.delegate = self
        datePicker.dataSource = self
        addContraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addContraints() {
        var constraints = [NSLayoutConstraint]()
        // add
        constraints.append(datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(datePicker.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        //activate
        NSLayoutConstraint.activate(constraints)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if showYear {
            return 3
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = 0
        if component == 1 { // day
            
            let comps = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            
            let month: Int = pickerView.selectedRow(inComponent: 0)+1 // add 1 to row index for range 1...12
            var year: Int
            year = comps.year!
            if month == 2 {
                if showYear {
                    let selectedYear = pickerView.selectedRow(inComponent: 2)
                    year = comps.year!-selectedYear
                    print(year)
                }
            }
            var selectMonthComps = DateComponents()
            selectMonthComps.year = year
            selectMonthComps.month = month
            selectMonthComps.day = 1
            
            var nextMonthComps = DateComponents()
            nextMonthComps.year = year
            nextMonthComps.month = month+1
            nextMonthComps.day = 1
            let thisMonthDate = Calendar.current.date(from: selectMonthComps)
            let nextMonthDate = Calendar.current.date(from: nextMonthComps)
            let difference = Calendar.current.dateComponents([.day], from: thisMonthDate!, to: nextMonthDate!)
            number = difference.day!
            return number
        } else if component == 0 { // month
            return months.count
        } else {
            let comp = Calendar.current.dateComponents([.year], from: Date())
            let year = comp.year!
            return year
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 || component == 2 { // if month or year changes, update number of days
            pickerView.reloadComponent(1)
        }
        refreshBirthdayText()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return months[row]
        } else if component == 1 {
            return String(format: "%d", row+1)
        } else {
            let comp = Calendar.current.dateComponents([.year], from: Date())
            let year = comp.year!
            return String(format: "%d", year-(row))
        }
    }
    func setupEditMode(date: Date) {
        print("Setup edit mode")
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let month = components.month else { return }
        guard let day = components.day else { return }
        datePicker.selectRow(month-1, inComponent: 0, animated: true)
        datePicker.selectRow(day-1, inComponent: 1, animated: true)
        refreshBirthdayText()
    }
    func setupDatePicker(date: Date) {
        print("Setup Date Picker")
        self.initialDate = date
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let month = components.month else { return }
        guard let day = components.day else { return }
        datePicker.selectRow(month-1, inComponent: 0, animated: true)
        datePicker.selectRow(day-1, inComponent: 1, animated: true)
        
        if showYear {
            guard let year = components.year else { return }
            print("Year: \(year)")
            let numberOfRowsInYears = datePicker.numberOfRows(inComponent: 2) - year
            datePicker.selectRow(numberOfRowsInYears, inComponent: 2, animated: true)
        }
    }
    func refreshBirthdayText() {
        print("Refresh Birthday Text")
        var year = Calendar.current.component(.year, from: .now)
        let month = datePicker.selectedRow(inComponent: 0)+1
        let day = datePicker.selectedRow(inComponent: 1)+1
        if showYear {
            year -= datePicker.selectedRow(inComponent: 2)
        }
        let text = showYear ? "\(month)/\(day)/\(year)" : "\(month)/\(day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = showYear ? "MM/dd/yyyy" : "MM/dd"
        initialDate = dateFormatter.date(from: text)
        customDelegate?.pickerViewSetDate(date: initialDate!)
    }
}
