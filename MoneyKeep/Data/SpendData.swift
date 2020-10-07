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
    
    public let Categories  = CategoryCollection() //категории трат
    public let Spends: SpendCollection

    private init(){
        Spends=SpendCollection(Categories);
    }
    
    public func getSpends(from: Date, to: Date, type: SpendType)->[Int: Float]{//затраты за период по категориям
        var res: [Int: Float] = [:]
        for cat in Categories{
            res[cat.ID] = 0
        }
        for spend in Spends{
            if spend.date<from || spend.category.type != type { continue }
            if spend.date>to { break }//у нас отсортированная коллекция, потому пропускаем
            res[spend.category.ID]? += spend.amount
        }
        return res
    }
    
}
