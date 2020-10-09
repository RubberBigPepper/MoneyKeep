//
//  Persistance.swift
//  MoneyKeep
//
//  Created by Albert on 09.10.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

class Persistance{
    static let shared=Persistance()//это у нас синглтон
    
    private let keyDemoMode="Persistance.DemoMode"
    private let keySecondRun="Persistance.SecondRun"

    //читаем и сохраняем режим демо
    var isDemoMode: Bool? {
        set{
            UserDefaults.standard.set(newValue, forKey: keyDemoMode)
        }
        get{
            if let key=UserDefaults.standard.value(forKey: keyDemoMode){
                return key as? Bool
            }
            else {
                return nil
            }
        }
    }
    
    //читаем и сохраняем режим второго и последущих запусков
    var isSecondRun: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: keyDemoMode)
        }
        get{
            return UserDefaults.standard.bool(forKey: keyDemoMode)
        }
    }

}
