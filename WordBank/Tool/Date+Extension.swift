//
//  Date+Extension.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import Foundation

extension Date {
    func format(in format: String = "yyyy/MM/dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
