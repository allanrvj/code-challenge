//
//  PostViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 17/06/2022.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadImage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadImage() {
        print("postData: \(postData.imageAddress)")
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documents.appendingPathComponent(postData.imageAddress)
        let image = UIImage(contentsOfFile: imageURL.path)
        imageView.image = image
    }

}
