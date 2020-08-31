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
    var mostUsage : [String]=[] //наиболее часто используемые картинки, поставим их в начало
    
    public var count: Int {//количество картинок в коллекции
        get{
            return mostUsage.count
        }
    }
    
    public func getImage(_ name: String)->UIImage?{
        moveToTop(name)
        return images[name]
    }
    
    public func getImage(_ at: Int)->UIImage?{
        if at<0 || at>=count { return nil }
        let name=mostUsage[at]
        moveToTop(name)
        return images[name]
    }
    
    public func getImageName(_ at: Int)->String?{
        if at<0 || at>=count { return nil }
        return mostUsage[at]
    }
    
    private func moveToTop(_ name: String){
        mostUsage.removeAll(where: {$0==name})
        mostUsage.insert(name, at: 0)
    }
    
    private func moveToTop(_ at: Int){
        let name=mostUsage[at]
        mostUsage.remove(at: at)
        mostUsage.insert(name, at: 0)
    }
}
