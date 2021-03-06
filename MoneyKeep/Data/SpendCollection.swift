//
//  SpendCollection.swift
//  MoneyKeep
//
//  Created by Albert on 20.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation
import CoreData
import UIKit
	
class SpendCollection: Sequence{//тут будет полный список расходов
    private var spends: [SpendItem] = []//все расходы будем писать тут
    private let categories: CategoryCollection;
    
    public var count: Int{//количество итемов
        return spends.count
    }
    
    func makeIterator() -> SpendIterator {
        return SpendIterator(spends)
    }
    
    public init(_ categories: CategoryCollection) {//конструктор, получим данные из CoreData
        self.categories=categories
        ReadFromCoredata()
    }
    
    private func resortSpends(){
        spends.sort { (a: SpendItem, b: SpendItem) -> Bool in //сразу отсортируем коллекцию по возрастанию
            return a.date < b.date
        }
    }
    
    public func addItem(_ item: SpendItem){//добавление расхода в коллекцию
        spends.append(item)
        resortSpends()
    }
    
    public func getItem(_ at: Int)->SpendItem?{//доступ к расходу по индексу
        if at<0 || at >= count {  return nil }
        return spends[at]
    }
    
    public func clear(){
        spends.removeAll()
    }
    
    public func SaveToCoredata() {
        ClearCoredata()
        let managedContext = AppDelegate.managedContext
        
        for spendItem in spends{//сохраняем итемы
            let entity =  NSEntityDescription.entity(forEntityName: "SpendsEntity", in: managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
         
            item.setValue(spendItem.amount, forKey: "amount")
            item.setValue(spendItem.date, forKey: "date")
            item.setValue(spendItem.text, forKey: "text")
            item.setValue(spendItem.category.ID, forKey: "cat_id")
        }
        categories.SaveToCoredata()
    }
    
    public func ReadFromCoredata(){
        categories.ReadFromCoredata()
        let managedContext = AppDelegate.managedContext
        spends.removeAll()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"SpendsEntity")
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {//читаем по одному итемы
            for result in results{
                let catID = result.value(forKey: "cat_id") as! Int
                let category = categories.findCategory(catID) ?? SpendCategory() //сопоставляем класс категории трат
                let spendItem = SpendItem(category: category,
                                          amount: result.value(forKey: "amount") as! Float,
                                          date: result.value(forKey: "date") as! Date,
                                          text: result.value(forKey: "text") as! String)
                spends.append(spendItem)
            }
         }
        resortSpends()
    }
    
    private func ClearCoredata(){
        let managedContext = AppDelegate.managedContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"SpendsEntity")
       
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {
            for result in results{
//                result.prepareForDeletion()
//                try! result.validateForDelete()
                managedContext.delete(result)
            }
        }
    }
}

struct SpendIterator: IteratorProtocol {//имплементация протокола итератора
    private var items: [SpendItem]
    private var index = 0

    init(_ spends:[SpendItem]) {
        self.items = spends
    }

    mutating func next() -> SpendItem? {
        var res: SpendItem? = nil
        if index<items.count{
            res=items[index]
            index+=1
        }
        return res
    }
}

