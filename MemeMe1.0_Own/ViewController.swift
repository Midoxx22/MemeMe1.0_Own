//
//  ViewController.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 03.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var topTextOutlet: UITextField!
    @IBOutlet weak var botTextOutlet: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    
    var shareEnabled = false
    
    let TextFieldDelegate = MemeTextDelegae()
    
    @IBAction func imagePicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        shareEnabled = true
    }
    
    @IBAction func cameraPicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        shareEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButtonOutlet.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
            shareButtonOutlet.isEnabled = shareEnabled
        
        
        //Subscribing to Keyboard Notifications
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextOutlet.defaultTextAttributes = memeTextAttributes
        botTextOutlet.defaultTextAttributes = memeTextAttributes
        topTextOutlet.delegate = TextFieldDelegate
        botTextOutlet.delegate = TextFieldDelegate
        
        //Center Text
        topTextOutlet.textAlignment = .center
        botTextOutlet.textAlignment = .center
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        
        imageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
        
        
        //Dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func generatedMemedImage() -> UIImage {
        //Hide Toolbar and NAV Bar also Share Button
        navBar.isHidden = true
        toolBar.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Bars
        navBar.isHidden = false
        toolBar.isHidden = false
        
        
        return memedImage
        
        
    }
    
    func save() {
        let meme = Meme(topText: topTextOutlet.text!, botText: botTextOutlet.text!, origImage: imageView.image!, memedImage: generatedMemedImage())
        
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your Meme has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        save()
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let image = generatedMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                self.save()
            }
            }
        }
    
    @IBAction func cancelButton(_ sender: Any) {
        imageView.image = nil
        topTextOutlet.text = "TOP TEXT"
        botTextOutlet.text = "BOT TEXT"
    }
    
    
    //MARK: MemeTextAttributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -6.0
        
    ]
    
    //MARK: MemeStruct
    struct Meme {
        var topText: String
        var botText: String
        var origImage: UIImage
        var memedImage: UIImage
        
    }
    
    //MARK: SubscribingToNotifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if botTextOutlet.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }


}

