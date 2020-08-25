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
	
class SpendCollection{//тут будет полный список расходов
    private var spends: [SpendItem] = []//все расходы будем писать тут
    private var categories: [SpendCategory] = []//все категории расходов будут тут
    
    public var count: Int{//количество итемов
        return spends.count
    }
    
    init() {//конструктор, получим данные из CoreData

    }
    
    deinit {//а тут сохраним в CoreData
        
    }
    
    func addItem(_ item: SpendItem){//добавление расхода в коллекцию
        spends.append(item)
        spends.sort { (a: SpendItem, b: SpendItem) -> Bool in //сразу отсортируем коллекцию по возрастанию
            return a.date < b.date
        }
    }
    
    func getItem(_ at: Int)->SpendItem?{//доступ к расходу по индексу
        if at<0 || at >= count {  return nil }
        return spends[at]
    }
    
    public func SaveToCoredata() {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SavingLearn")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        let managedContext = persistentContainer.viewContext
        
        for spendItem in spends{//сохраняем итемы
            let entity =  NSEntityDescription.entity(forEntityName: "SpendsEntity", in: managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
         
            item.setValue(spendItem.amount, forKey: "amount")
            item.setValue(spendItem.date, forKey: "date")
            item.setValue(spendItem.text, forKey: "text")
            item.setValue(spendItem.category.ID, forKey: "cat_id")
        }
        
        for category in categories{//сохраняем категории
            let entity =  NSEntityDescription.entity(forEntityName: "CategoryEntity", in: managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
         
            item.setValue(category.ID, forKey: "cat_id")
            item.setValue(category.name, forKey: "name")
            item.setValue(category.imagePath, forKey: "icon")
        }
    }
    
    public func ReadFromCoredata(){
        let persistentContainer: NSPersistentContainer = {
                 let container = NSPersistentContainer(name: "SavingLearn")
                 container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                     if let error = error as NSError? {
                         fatalError("Unresolved error \(error), \(error.userInfo)")
                     }
                 })
                 return container
             }()
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"SpendsEntity")
        
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]
        todoList.removeAll()
        if let results = fetchedResults {
            for result in results{
                let todo=Todo(what: result.value(forKey: "what") as! String, when: result.value(forKey: "when") as! Date)
                todoList.append(todo)
            }
         }
    }
}
