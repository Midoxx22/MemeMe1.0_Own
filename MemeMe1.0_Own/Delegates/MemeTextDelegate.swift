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
    
    //Clear Standard Text when Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    //Return Dismisses the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    //Uppercased Letters Only
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        return false
    }
}
