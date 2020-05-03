//
//  MemeTextDelegate.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 03.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegae: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
