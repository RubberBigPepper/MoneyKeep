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
    
    public var firstDate: Date {//это не свиданка, это первая дата в расходах
        get{
            if let res=Spends.getItem(0)?.date {//надо тут как то покороче написать
                return res
            }
            return Date()
        }
    }
    
    public var endDate: Date {//это конечная дата в расходах
        get{
            if let res=Spends.getItem(Spends.count-1)?.date {//надо тут как то покороче написать
                return res
            }
            return Date()
        }
    }

    private init(){
        Categories = CategoryCollection()
        Spends = SpendCollection(Categories)
    }

    public func saveDataToCore(){//сохранение данных в кордату
        Categories.SaveToCoredata()
        Spends.SaveToCoredata()
    }
    
    public func getSpends(from: Date, to: Date, type: SpendType)->[Int: Float]{//затраты за период по категориям
        var res: [Int: Float] = [:]
        for cat in Categories{
            res[cat.ID] = 0
        }
        for spend in Spends{
            if spend.date < from || spend.category.type != type { continue }
            if spend.date >= to { break }//у нас отсортированная коллекция, потому пропускаем
            res[spend.category.ID]? += spend.amount
        }
        return res
    }
    
    public func generateDemoData(){//генерация демо данных
        Spends.clear()
        let monthYear=Date().toMonthYear()
        for month in monthYear-6...monthYear{//возьмем несколько месяцев от текущей даты
            for cat in Categories {
                let rnd = Int.random(in: 0..<10)//не все категории будут учавствовать
                if rnd>6 { continue }
                let amount = Float(Int.random(in: 5..<1000000)) * 0.01
                if let date = Date.fromMonthYear(month, Int.random(in: 0..<29)) {
                    Spends.addItem(SpendItem(category: cat, amount: amount, date: date, text: NSLocalizedString("auto_generated", comment: "")))
                }
            }
        }
    }
}
