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

class CategoryCollection{
    public static let Categories: CategoryCollection = CategoryCollection() //реализуем синглтон

    private var categories: [SpendCategory] = []//все категории расходов будут тут
    
    public var count: Int{//количество категорий
        get{
            return categories.count
        }
    }
    
    private var __id: Int = 0
    
    private func nextID()->Int{
        __id+=1
        return __id
    }
    
    private init(){
        ReadFromCoredata()
        if count == 0 {//ничего не прочитано, поэтому сгенерируем новые
            addCatehory(SpendCategory(imagePath: "", name: "Гигиена", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Еда", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Жилье", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Здоровье", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Одежда", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Кафе", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Машина", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Дом. животные", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Подарки", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Развлечения", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Связь", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Спорт", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Счета", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Такси", ID: nextID(), type: .outcome))
            addCatehory(SpendCategory(imagePath: "", name: "Транспорт", ID: nextID(), type: .outcome))
            
            addCatehory(SpendCategory(imagePath: "", name: "Депозит", ID: nextID(), type: .income))
            addCatehory(SpendCategory(imagePath: "", name: "Зарплата", ID: nextID(), type: .income))
            addCatehory(SpendCategory(imagePath: "", name: "Дивиденды", ID: nextID(), type: .income))
            addCatehory(SpendCategory(imagePath: "", name: "Гонорар", ID: nextID(), type: .income))
            addCatehory(SpendCategory(imagePath: "", name: "Прочие доходы", ID: nextID(), type: .income))
            SaveToCoredata()
        }
    }
    
    public func addCatehory(_ category: SpendCategory){//добавление категории
        if FindCategory(category.ID) != nil { return }//такая категория уже есть, пропускаем
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
        let at: Int = FindCategory(ID)
        if at<0 { return }
        categories.remove(at: at)
    }
        
    private func FindCategory(_ catID: Int)->Int{//поищем категорию с указанным ID
        for (idx, category) in self.categories.enumerated(){
            if category.ID==catID { return idx }
        }
        return -1
    }
    
    public func FindCategory(_ catID: Int)->SpendCategory?{//поищем категорию с указанным ID, если нет - nil
        return getCategory(FindCategory(catID))
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
                let category = SpendCategory(imagePath: result.value(forKey: "icon") as! String,
                                             name: result.value(forKey: "name") as! String,
                                             ID: result.value(forKey: "cat_id") as! Int,
                                             type: result.value(forKey: "type") as! SpendType)
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
                result.prepareForDeletion()
            }
        }
        AppDelegate.saveContext()
    }
        
}
