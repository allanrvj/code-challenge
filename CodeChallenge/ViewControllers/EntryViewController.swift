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
    private var imageFilename: URL!
    
    private var keyboardToolbar = UIToolbar()
    private var activeTextField: UITextField?

    private var currentDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        
        keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        keyboardToolbar.barStyle = .default
        keyboardToolbar.backgroundColor = .white
        keyboardToolbar.items = [
            UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: self, action: #selector(previous)),
            UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(forward)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endEditing))
        ]
        
        totalTextField.delegate = self
        currencyTextField.delegate = self
        descriptionTextField.delegate = self
        
        totalTextField.inputAccessoryView = keyboardToolbar
        currencyTextField.inputAccessoryView = keyboardToolbar
        descriptionTextField.inputAccessoryView = keyboardToolbar
        
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
        if imagePicked != nil, let data = imagePicked.pngData() {
            imageFilename = documents.appendingPathComponent("\(UUID().uuidString).png")
            do {
                try data.write(to: imageFilename)
                // Open a local realm
                let localRealm = try! Realm()
                print("path: \(imageFilename.absoluteString)")
                let postData = PostData(imageAddress: imageFilename.absoluteString)
                print("date: \(currentDateString!)")
                postData.date = currentDateString!
                print("total: \(totalTextField.text!)")
                postData.total = totalTextField.text!
                print("currency: \(currencyTextField.text!)")
                postData.currency = currencyTextField.text!
                print("descString: \(descriptionTextField.text!)")
                postData.descString = descriptionTextField.text!
                
                try localRealm.write({
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
        if activeTextField == nil { return }
        activeTextField!.resignFirstResponder()
    }
    
    @objc internal func previous() {
        if activeTextField == currencyTextField {
            totalTextField.becomeFirstResponder()
        } else if activeTextField == descriptionTextField {
            currencyTextField.becomeFirstResponder()
        }
    }
    
    @objc internal func forward() {
        if activeTextField == totalTextField {
            currencyTextField.becomeFirstResponder()
        } else if activeTextField == currencyTextField {
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
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, activeTextField != nil {
            
            if activeTextField == totalTextField {
                view.frame.origin.y = -150
            } else if activeTextField == currencyTextField {
                view.frame.origin.y = -200
            } else if activeTextField == descriptionTextField {
                view.frame.origin.y = -250
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}

