//
//  PostData.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 16/06/2022.
//

import Foundation
import RealmSwift

class PostData: Object {
    
    @Persisted var imageName: String = ""
    @Persisted var date: String = ""
    @Persisted var total: String = ""
    @Persisted var currency: String = ""
    @Persisted var descString: String = ""
    
    convenience init(imageName: String) {
        self.init()
        self.imageName = imageName
    }
}
