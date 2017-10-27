//
//  File.swift
//  VK
//
//  Created by Eugene Khizhnyak on 27.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

extension Date {
    func dateByAdding(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func timeIntervalForDate(_ date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
}
