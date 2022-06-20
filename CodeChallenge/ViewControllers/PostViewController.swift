//
//  PostViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 17/06/2022.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        dateLabel.text = postData.date
        totalLabel.text = postData.total
        currencyLabel.text = postData.currency
        descriptionLabel.text = postData.descString
    }
    
    private func loadImage() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documents.appendingPathComponent(postData.imageName)
        let image = UIImage(contentsOfFile: imageURL.path)
        imageView.image = image
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Warning", message: "Delete entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            do {
                // Delete the picture
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
                let imageURL = documentsPath.appendingPathComponent(self.postData.imageName)
                // Check if file exists
                if FileManager.default.fileExists(atPath: imageURL) {
                    // Delete file
                    try FileManager.default.removeItem(atPath: imageURL)
                    print("File deleted: \(imageURL)")
                } else {
                    print("File does not exist")
                }
                
                // Open a local realm
                let localRealm = try! Realm()
                try localRealm.write({
                    // Delete details from database
                    localRealm.delete(self.postData)
                })
                
                self.navigationController?.popViewController(animated: true)
                
            } catch let error as NSError {
                print("An error took place: \(error)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Do nothing
        }))
        present(alert, animated: true, completion: nil)

    }

}
