//
//  CategoryCollection.swift
//  MoneyKeep
//
//  Created by Albert on 28.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CategoryCollection: Sequence{

    private var categories: [SpendCategory] = []//все категории расходов будут тут

    public var count: Int{//количество категорий
        get{
            return categories.count
        }
    }

    func makeIterator() -> CategoryIterator {
        return CategoryIterator(categories)
    }

    private var __id: Int = 0

    private func nextID()->Int{
        __id+=1
        return __id
    }

    private func getCategories(_ type: SpendType) -> [SpendCategory]{
        var res: [SpendCategory]=[]
        for cat in categories{
            if cat.type == type {
                res.append(cat)
            }
        }
        return res
    }

    public var incomeCat:[SpendCategory]{
        get{
            return getCategories(.income)
        }
    }

    public var outcomeCat:[SpendCategory]{
        get{
            return getCategories(.outcome)
        }
    }

    public init(){
        ReadFromCoredata()
        if count == 0 {//ничего не прочитано, поэтому сгенерируем новые
            makeCategory("beauty", "beauty", .outcome)
            makeCategory("food", "food", .outcome)
            makeCategory("house", "house", .outcome)
            makeCategory("medicine", "medicine", .outcome)
            makeCategory("clothes", "clothes", .outcome)
            makeCategory("fuel_station", "fuel_station", .outcome)
            makeCategory("hobby", "hobby", .outcome)
            makeCategory("gift", "gift", .outcome)
            makeCategory("entertainment", "entertainment", .outcome)
            makeCategory("service", "service", .outcome)
            makeCategory("sport", "sport", .outcome)
            makeCategory("bill", "bill", .outcome)
            makeCategory("car", "car", .outcome)
            makeCategory("transport", "transport", .outcome)

            makeCategory("safe", "safe", .income)
            makeCategory("money", "money", .income)
            makeCategory("passive_income", "passive_income", .income)
            makeCategory("tag", "tag", .income)
            makeCategory("miscellaneous", "miscellaneous", .income)
            SaveToCoredata()
        }
    }
    
    private func makeCategory(_ imagePath: String, _ keyStr: String, _ type: SpendType){
        addCategory(SpendCategory(imagePath: imagePath, name: String.localized(keyStr), ID: nextID(), type: type))
    }

    public func addCategory(_ category: SpendCategory){//добавление категории
        if findCategory(category.ID) != nil { return }//такая категория уже есть, пропускаем
        categories.append(category)
    }

    public func getCategory(_ at: Int)->SpendCategory?{//доступ к категории по индексу
        if at<0 || at >= count {  return nil }
        return categories[at]
    }

    public func removeCategoryAt(_ at: Int){//удаление категории
        if at<0 || at >= count {  return }
        categories.remove(at: at)
    }

    public func removeCategory(_ ID: Int){//удаление категории
        let at: Int = findCategory(ID)
        if at<0 { return }
        categories.remove(at: at)
    }

    private func findCategory(_ catID: Int)->Int{//поищем категорию с указанным ID
        for (idx, category) in self.categories.enumerated(){
            if category.ID==catID { return idx }
        }
        return -1
    }

    public func findCategory(_ catID: Int)->SpendCategory?{//поищем категорию с указанным ID, если нет - nil
        return getCategory(findCategory(catID))
    }


    public func SaveToCoredata() {
        ClearCoredata()
        let managedContext = AppDelegate.managedContext

        for category in categories{//сохраняем категории
            let entity =  NSEntityDescription.entity(forEntityName: "CategoryEntity", in: managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)

            item.setValue(category.ID, forKey: "cat_id")
            item.setValue(category.name, forKey: "name")
            item.setValue(category.imagePath, forKey: "icon")
            switch category.type {
            case .income:
                item.setValue(1, forKey: "type")
            default:
                item.setValue(0, forKey: "type")
            }
        }
        AppDelegate.saveContext()
    }

    public func ReadFromCoredata(){//чтение категорий
        categories.removeAll()
        let managedContext = AppDelegate.managedContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"CategoryEntity")
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {
            for result in results{
                var type = SpendType.outcome
                let value=result.value(forKey: "type") as! Int
                if value == 0 { type = .outcome}
                else { type = .income}
                let category = SpendCategory(imagePath: result.value(forKey: "icon") as! String,
                                             name: result.value(forKey: "name") as! String,
                                             ID: result.value(forKey: "cat_id") as! Int,
                                             type: type)
                categories.append(category)
            }
        }
    }

    private func ClearCoredata(){
        let managedContext = AppDelegate.managedContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"CategoryEntity")

        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {
            for result in results{
//                result.prepareForDeletion()
                managedContext.delete(result)
            }
        }
        AppDelegate.saveContext()
    }

}

struct CategoryIterator: IteratorProtocol {//имплементация протокола итератора
    private let items: [SpendCategory]
    private var index = 0

    init(_ categories:[SpendCategory]) {
        self.items = categories
    }

    mutating func next() -> SpendCategory? {
        var res: SpendCategory? = nil
        if index<items.count{
            res=items[index]
            index+=1
        }
        return res
    }
}
