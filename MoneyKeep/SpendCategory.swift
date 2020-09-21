//
//  CategoryExpense.swift
//  MoneyKeep
//
//  Created by Albert on 20.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation
import UIKit


class SpendCategory{//категория расходов
    var imagePath : String //иконка для отрисовки
    var name : String //название категории
    let ID : Int //идентификатор категории
    let type : SpendType
    
    init(imagePath: String, name: String, ID : Int, type: SpendType) {
        self.imagePath=imagePath
        self.name=name
        self.ID=ID
        self.type=type
    }
    
    init() {
        self.imagePath=""
        self.name=""
        self.ID=0
        self.type = .outcome
    }
}
