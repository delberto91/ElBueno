//
//  Date.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 3/5/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation


extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    
}
