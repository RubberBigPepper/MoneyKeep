//
//  ColorSet.swift
//  MoneyKeep
//
//  Created by Albert on 09.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ColorSet{//класс выполняет роль хранилища и генерации уникальных цветов для чарта
    
    var colorsInternal: [UIColor] = []//уникальные цвета
    
    private static let singleTonColorSet: ColorSet = ColorSet();
    
    public static var colors: [UIColor]{
        get{
            return singleTonColorSet.colorsInternal
        }
    }
    
    init(_ maxColor: Int = 30) {
        ReadFromCoredata()
        if colorsInternal.count==0{//цвета не прочитались - генерируем новые
            colorsInternal = colorsOfCharts(maxColor)
            SaveToCoredata()
        }
    }
    
    private func colorsOfCharts(_ count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    public func SaveToCoredata() {
        ClearCoredata()
        let managedContext = AppDelegate.managedContext
        
        for color in colorsInternal{//сохраняем цвета
            let entity =  NSEntityDescription.entity(forEntityName: "ColorSetEntity", in: managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
            item.setValue(color, forKey: "color")
        }
        AppDelegate.saveContext()
    }
    
    public func ReadFromCoredata(){//чтение категорий
        colorsInternal.removeAll()
       let managedContext = AppDelegate.managedContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ColorSetEntity")
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {
            for result in results{
                let color = result.value(forKey: "color") as! UIColor
                colorsInternal.append(color)
            }
        }
    }
    
    private func ClearCoredata(){
        let managedContext = AppDelegate.managedContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ColorSetEntity")
       
        let fetchedResults = try!managedContext.fetch(fetchRequest) as? [NSManagedObject]

        if let results = fetchedResults {
            for result in results{
                result.prepareForDeletion()
            }
        }
    }
}
