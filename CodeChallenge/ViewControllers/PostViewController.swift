//
//  PostViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 17/06/2022.
//

import UIKit

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
        let imageURL = documents.appendingPathComponent(postData.imageAddress)
        let image = UIImage(contentsOfFile: imageURL.path)
        imageView.image = image
    }

}
