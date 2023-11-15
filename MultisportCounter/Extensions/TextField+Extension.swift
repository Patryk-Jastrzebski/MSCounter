//
//  TextField+Extension.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 11/11/2023.
//

import SwiftUI

final class DatePickerTextField: UITextField {
    @Binding var date: Date?
    private let datePicker = UIDatePicker()
    
    init(date: Binding<Date?>, frame: CGRect) {
        self._date = date
        super.init(frame: frame)
        inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerDidSelect(_:)), for: .valueChanged)
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "pl-PL")
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Gotowe", style: .plain, target: self, action: #selector(dismissTextField))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        inputAccessoryView = toolBar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func datePickerDidSelect(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    @objc private func dismissTextField() {
        resignFirstResponder()
    }
    
}

struct DatePickerInputView: UIViewRepresentable {
    @Binding var date: Date?
    let placeholder: String
    let dateFormatter: DateFormatterHelper
    
    var dateString: String? {
        dateFormatter.string(from: date, format: .dateAndTimeWithPartialMonth, withTimeZone: false)
    }
    
    init(date: Binding<Date?>, placeholder: String, dateFormatter: DateFormatterHelper) {
        self._date = date
        self.placeholder = placeholder
        self.dateFormatter = dateFormatter
    }
    
    func updateUIView(_ uiView: DatePickerTextField, context: Context) {
        if let date = dateString {
            uiView.text = "\(date)"
        }
    }
    
    func makeUIView(context: Context) -> DatePickerTextField {
        let dptf = DatePickerTextField(date: $date, frame: .zero)
        dptf.textAlignment = .right
        dptf.textColor = UIColor(.blue)
        dptf.placeholder = placeholder
        if let date = dateString {
            dptf.text = "\(date)"
        }
        
        return dptf
    }
    
}
