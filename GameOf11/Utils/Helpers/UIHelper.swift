//
//  UIHelper.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
    init() {
        
    }
    
    func getHeightForText(forText text: String,
                          andFont font: UIFont,
                          andWidth width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: width,
                                                  height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func setDatePicker(atTextField textField: UITextField, onDoneClicked doneClicked: @escaping(String) -> Void) {
        // DatePicker
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: getScreenWidth(), height: 216))
//        datePicker.backgroundColor = App.sharedInstance.colors.border
//        datePicker.setValue(App.sharedInstance.colors.loginBg, forKeyPath: "textColor")
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
//        toolBar.barTintColor = App.sharedInstance.colors.commonBg
        toolBar.isTranslucent = false
//        toolBar.tintColor = App.sharedInstance.colors.navBarBg
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.style = .plain
        doneButton.target = self
        _ = doneButton.reactive.tap.observeNext {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.timeStyle = .none
            let dateStr = dateFormatter1.string(from: datePicker.date)
            textField.text = dateStr
            textField.resignFirstResponder()
            doneClicked(dateStr)
        }
        
        let cancelBtn = UIBarButtonItem()
        cancelBtn.title = "Cancel"
        cancelBtn.style = .plain
        cancelBtn.target = self
        _ = cancelBtn.reactive.tap.observeNext {
            textField.resignFirstResponder()
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelBtn, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
}
