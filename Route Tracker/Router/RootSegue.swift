//
//  RootSegue.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation
import UIKit

class RootSegue: UIStoryboardSegue {
    override func perform() {
        UIApplication.shared.keyWindow?.rootViewController = destination
    }
}
