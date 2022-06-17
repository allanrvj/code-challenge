//
//  Utils.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 17/06/2022.
//

import Foundation
import RealmSwift

class Utils {
    
    static func getTodaysLocalizedDate() -> String {
        let now = Date()

        let formatter =  DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, d, MMMM, yyyy"
        
        let outputDate = formatter.string(from: now)

        return outputDate
    }

    static func getAllPostDataFromRealm() -> [PostData] {
        let realm = try! Realm()
        let postDataObjects = realm.objects(PostData.self)
        return postDataObjects.toArray(type: PostData.self)
    }

}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
