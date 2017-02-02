//
//  ViewController.swift
//  MemeMe
//
//  Created by Flavio Kreis on 17/01/17.
//  Copyright © 2017 Flavio Kreis. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraPickButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraPickButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        
        shareButton.isEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    private func setupTextField(_ field: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
            ] as [String : Any]
        
        field.defaultTextAttributes = memeTextAttributes
        field.delegate = self
        field.textAlignment = .center
        field.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancelEditMeme(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: Select images
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        print(info)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            topTextField.isHidden = false
            bottomTextField.isHidden = false
            shareButton.isEnabled = true
            
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Generate meme image
    
    @IBAction func shareMeme(_ sender: Any) {
        self.view.endEditing(true)
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memedImage: memedImage)
                
                self.dismiss(animated: true)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
                        originalImage: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        setToolbarHidden(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setToolbarHidden(false)
        
        return memedImage
    }
    
    private func setToolbarHidden(_ isHidden: Bool) {
        topBar.isHidden = isHidden
        bottomBar.isHidden = isHidden
    }
    
    //MARK: Keyboard code

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}

