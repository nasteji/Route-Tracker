//
//  User.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
