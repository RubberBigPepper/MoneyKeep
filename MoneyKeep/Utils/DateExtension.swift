//
//  DateExtesnsion.swift
//  MoneyKeep
//
//  Created by Albert on 29.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

extension Date {
    public func toString(_ format: String)->String{//просто дата в виде отформатированной строки
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public func toString()->String{//просто дата в виде отформатированной строки
        return toString("dd.MM.yyyy")
    }
    
    public static func fromString(_ string: String, _ format: String)->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}
