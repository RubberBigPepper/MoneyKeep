//
//  SpendData.swift
//  MoneyKeep
//
//  Created by Albert on 06.10.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

class  SpendData{//этот класс будет все данные о расходах собирать и выдавать готовые выборки по месяцам

    public static let Data = SpendData()//синглтон данных о тратах и категориях
    
    public let Categories: CategoryCollection
    public let Spends: SpendCollection

    private init(){
        Categories = CategoryCollection()
        Spends = SpendCollection(Categories)
    }

    public func getSpends(from: Date, to: Date, what: SpendType)->[Int: Float]{//затраты за период. Сперва ID категории, потом затраты
        var res: [Int:Float] = [:]
        for n in 0..<Categories.count{
            if let cat = Categories.getCategory(n) {
                res[cat.ID] = 0
            }
        }

        return res //пока заглушка
    }

    public func saveDataToCore(){//сохранение данных в кордату
        Categories.SaveToCoredata()
        Spends.SaveToCoredata()
    }
}
