//
//  ViewController.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 03.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var topTextOutlet: UITextField!
    @IBOutlet weak var botTextOutlet: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    
    //MARK: API TESTING
    @IBAction func testAPIButton(_ sender: Any) {
        MemeAPI.requestTrendingMemesAPI()
    }
    
    //MARK: Variables and Constants
    let TextFieldDelegate = MemeTextDelegae()
    
    //MARK: IBActions
    
    //Image Picker from Photo Libary
    @IBAction func imagePicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Image Picker from Camera
    @IBAction func cameraPicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Save Button
    @IBAction func saveButton(_ sender: Any) {
        save()
    }
    
    //Share Button
    @IBAction func shareButton(_ sender: Any) {
        let image = generatedMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        //Completion Handler to Save Image after Success
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                self.save()
            }
            }
        }
    
    //Cancel to Default
    @IBAction func cancelButton(_ sender: Any) {
        imageView.image = nil
        topTextOutlet.text = "TOP TEXT"
        botTextOutlet.text = "BOT TEXT"
        shareButtonOutlet.isEnabled = false
    }
    
    //MARK: Functions
    
    //View Will Appear Camera Source Check and Disabled Share Button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButtonOutlet.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButtonOutlet.isEnabled = false
        //Subscribing to Keyboard Notifications
        subscribeToKeyboardNotifications()
    }
    
    //Unsubscribe from Keyboard Notification
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //Set Text Attributes and Delegates - also Text Alignment and Image View behaviour
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextOutlet.defaultTextAttributes = memeTextAttributes
        botTextOutlet.defaultTextAttributes = memeTextAttributes
        topTextOutlet.delegate = TextFieldDelegate
        botTextOutlet.delegate = TextFieldDelegate
        //Center Text
        topTextOutlet.textAlignment = .center
        botTextOutlet.textAlignment = .center
        
        //Settings for Image View
        imageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
    }
    
    //Cancel PickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss
        dismiss(animated: true, completion: nil)
    }
    
    //Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Dictionary Key to Image for Displaying
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //Set Image in Image View
            imageView.image = image
        }
        
        //Enable Share Button
        shareButtonOutlet.isEnabled = true
        //Dismiss
        dismiss(animated: true, completion: nil)
    }
    
    //Generate Meme including Hide Nav and Toolbar
    func generatedMemedImage() -> UIImage {
        //Hide Bars
        hideBars(status: true)
        
        //Generate Meme
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Bars
        hideBars(status: false)
        
        //Return UIImage
        return memedImage
    }
    
    //Hide and Show Navbar Function
    func hideBars(status: Bool) {
        navBar.isHidden = status
        toolBar.isHidden = status
    }
    
    //Save Function called at Completion in Activity VC or Save Button Pressed
    func save() {
        let meme = Meme(topText: topTextOutlet.text!, botText: botTextOutlet.text!, origImage: imageView.image!, memedImage: generatedMemedImage())
        
        //Save Function to Photo Album
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        //Add to Shared Data Model in App Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    //Alert View if Saving was Successfull or not
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
    

    //MARK: MemeTextAttributes
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -6.0
    ]
    
    //MARK: MemeStruct
    /*
    struct Meme {
        var topText: String
        var botText: String
        var origImage: UIImage
        var memedImage: UIImage
    }
    */
    //MARK: SubscribingToNotifications

    //Subscribing to NSNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribing to NSNotifications
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //View Shifting Height only if Bottom Text is being edited
    @objc func keyboardWillShow(_ notification:Notification) {
        if botTextOutlet.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Hide Keyboard after Editing
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //Get the Keyboard Height for Shifting
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    //MARK: API TESTING FUNCTIONS
    
    
}
