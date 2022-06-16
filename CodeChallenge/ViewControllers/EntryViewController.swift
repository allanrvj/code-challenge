//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 16/06/2022.
//

import UIKit
import RealmSwift

class EntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imagePicker: UIImagePickerController!
    private var imagePicked: UIImage!
    private var imageFilename: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
//        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
    }

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
        if let data = imagePicked.pngData() {
            imageFilename = documents.appendingPathComponent("\(UUID().uuidString).png")
            do {
                try data.write(to: imageFilename)
                // Open a local realm
                let localRealm = try! Realm()
                print("path: \(imageFilename.absoluteString)")
                let postData = PostData(imageAddress: imageFilename.absoluteString)
                postData.currency = currencyTextField.text
                postData.total = totalTextField.text!
                
                try localRealm.write({
                    localRealm.add(postData)
                })
                
                dismiss(animated: true)
            } catch {
                print("Unable to save data")
            }
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
}

