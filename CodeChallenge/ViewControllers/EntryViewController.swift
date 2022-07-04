//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 16/06/2022.
//

import UIKit
import RealmSwift

class EntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!

    private var imagePicker: UIImagePickerController!
    private var imagePicked: UIImage!
    private var imageFilename: String!
    
    private var activeTextField: UITextField?

    private var currentDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        
        // Prev, Next, OK buttons on top of the keyboard
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        keyboardToolbar.barStyle = .default
        keyboardToolbar.backgroundColor = .white
        keyboardToolbar.items = [
            UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: self, action: #selector(previous)),
            UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(forward)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endEditing))
        ]
        
        totalTextField.inputAccessoryView = keyboardToolbar
        currencyTextField.inputAccessoryView = keyboardToolbar
        descriptionTextField.inputAccessoryView = keyboardToolbar
        
        totalTextField.delegate = self
        currencyTextField.delegate = self
        descriptionTextField.delegate = self
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentDateString = Utils.getTodaysLocalizedDate()
        currentDateLabel.text = "\(currentDateString!)"
    }
    
    // hide the status bar when this view is presented
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        // get the location of documents directory
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if imagePicked != nil, let data = imagePicked.jpegData(compressionQuality: 1.0) {
            
            imageFilename = "\(UUID().uuidString).jpeg"
            let destinationFilename = documents.appendingPathComponent(imageFilename)
            do {
                // Save the image to the documents directory
                try data.write(to: destinationFilename)
                print("File saved: \(destinationFilename)")
                // Open a local realm
                let localRealm = try! Realm()
                let postData = PostData(imageName: imageFilename)
                postData.date = currentDateString!
                postData.total = totalTextField.text!
                postData.currency = currencyTextField.text!
                postData.descString = descriptionTextField.text!
                
                try localRealm.write({
                    // Save the details to the Realm DB.
                    localRealm.add(postData)
                })
                
                dismiss(animated: true)
            } catch {
                print("Unable to save data")
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please take a picture", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // Do nothing
            }))
            present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    
    //MARK: - Image Picker Controller Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        imagePicked = info[.originalImage] as? UIImage
        
        imageView.image = imagePicked
    }
    
    //MARK: - Text Field Delegate
    
    // hide the keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc internal func endEditing() {
        activeTextField?.resignFirstResponder()
    }
    
    @objc internal func previous() {
        if currencyTextField.isFirstResponder {
            totalTextField.becomeFirstResponder()
        } else if descriptionTextField.isFirstResponder {
            currencyTextField.becomeFirstResponder()
        }
    }
    
    @objc internal func forward() {
        if totalTextField.isFirstResponder {
            currencyTextField.becomeFirstResponder()
        } else if currencyTextField.isFirstResponder {
            descriptionTextField.becomeFirstResponder()
        }
    }

    // MARK: - Keyboard
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // When keyboard is activated upon a text field being in focus,
        // raise the view so that the keyboard is not blocking the text field
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, activeTextField != nil {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            // Calculate how much to raise based on keyboard height and text field y-position
            if activeTextField == totalTextField {
                view.frame.origin.y = -(totalTextField.frame.origin.y - keyboardHeight)
            } else if activeTextField == currencyTextField {
                view.frame.origin.y = -(currencyTextField.frame.origin.y - keyboardHeight)
            } else if activeTextField == descriptionTextField {
                view.frame.origin.y = -(descriptionTextField.frame.origin.y - keyboardHeight)
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Reset the position of the view
        view.frame.origin.y = 0
    }
}
