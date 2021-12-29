//
//  MainRouter.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 25.12.2021.
//

import Foundation
import UIKit

final class MainRouter: BaseRouter {
    func toMap(usseles: String) {
        perform(segue: "toMap") { (controller: MapViewController) in
            controller.usselesExampleVariable = usseles
        }
    }
    
    func toLaunch() {
        perform(segue: "toLaunch")
    }
    
}
