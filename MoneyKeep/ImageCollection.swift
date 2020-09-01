//
//  ImageCollection.swift
//  MoneyKeep
//
//  Created by Albert on 31.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation
import UIKit
//класс, содержащий битмапы для отрисовки
class ImageCollection{
    var images: [String: UIImage] = [:]//главный словарь
    
    public var count: Int {//количество картинок в коллекции
        get{
            return images.count
        }
    }
    
    public func addImage(_ name: String){
        removeImage(name)
        images[name]=UIImage(named: name)
    }
    
    public func removeImage(_ name: String){
        images.removeValue(forKey: name)
    }
    
    public func getImage(_ name: String, createNew: Bool = false)->UIImage?{
        if images.index(forKey: name) == nil {//такого еще нет
            if createNew {//создаем новый как указано
                addImage(name)
                return getImage(name, createNew: false)
            }
            else{
                return nil
            }
        }
        return images[name]
    }
    
    public func Clear(){//очистка коллекции
        images.removeAll()
    }
}
