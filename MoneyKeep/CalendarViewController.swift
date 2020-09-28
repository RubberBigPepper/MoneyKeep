//
//  CalendarViewController.swift
//  MoneyKeep
//
//  Created by Albert on 28.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit
import KDCalendar

class CalendarViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // calendarView.delegate = self
      //  calendarView.dataSource = self
    }
    
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }

    func startDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(0))
    }
    
    func endDate() -> Date {
        return Date()
    }
    
    func headerString(_ date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
    
}
