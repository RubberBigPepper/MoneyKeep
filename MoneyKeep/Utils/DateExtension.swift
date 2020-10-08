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
    
    public static func from(_ year: Int, _ month: Int, _ day: Int) -> Date?
    {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(calendar: gregorianCalendar, year: year, month: month, day: day)
        return gregorianCalendar.date(from: dateComponents)
    }
    
    public func getComponent(_ component: Calendar.Component)->Int{
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    public func toMonthYear()->Int {//дату в число
        return self.getComponent(.year) * 12 + self.getComponent(.month)
    }
    
    public static func fromMonthYear(_ monthYear: Int,_ day: Int = 1)-> Date?{//число даты В дату
        let year = monthYear / 12
        let month = monthYear % 12
        return Date.from(year, month, day)
    }
}
