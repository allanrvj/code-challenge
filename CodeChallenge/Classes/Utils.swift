//
//  Utils.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 17/06/2022.
//

import Foundation

class Utils {
    
    static func getTodaysLocalizedDate() -> String {
        let now = Date()

        let formatter =  DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, d, MMMM, yyyy"
        
        let outputDate = formatter.string(from: now)

        return outputDate
    }

}
