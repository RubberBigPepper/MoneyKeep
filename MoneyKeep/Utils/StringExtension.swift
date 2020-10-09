//
//  StringExtension.swift
//  MoneyKeep
//
//  Created by Albert on 09.10.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import Foundation

extension String {//для строк сделаем тоже некоторые добавки
    static func localized(_ key: String)->String{
        return NSLocalizedString(key, comment: "")
    }
}
