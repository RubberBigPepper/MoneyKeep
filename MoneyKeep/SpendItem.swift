//
//  ExpenseItem.swift
//  MoneyKeep
//
//  Created by Albert on 20.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

class SpendItem{//класс, содержащий одну позицию расхода (знак -) или дохода (+)
    let category : SpendCategory //категория расхода
    let amount : Float //количество расхода, если расход, то минус, если доход, то положительный
    let date : Date //ну и момент расхода
    let text : String //комментарии
    
    init(category: SpendCategory, amount: Float, date: Date, text: String) {
        self.category = category
        self.amount = amount
        self.date = date
        self.text = text
    }
}
