//
//  PostData.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 16/06/2022.
//

import Foundation
import RealmSwift

class PostData: Object {
    
    @Persisted var imageAddress: String = ""
    @Persisted var date: String?
    @Persisted var total: String = ""
    @Persisted var currency: String? = ""
    
    convenience init(imageAddress: String) {
        self.init()
        self.imageAddress = imageAddress
    }
}
