//
//  LaunchRouter.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation

final class LaunchRouter: BaseRouter {
    func toMain() {
        perform(segue: "toMain")
    }
    func toAuth() {
        perform(segue: "toAuth")
    }
}
