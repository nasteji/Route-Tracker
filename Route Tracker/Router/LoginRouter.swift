//
//  LoginRouter.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation

final class LoginRouter: BaseRouter {
    func toMain() {
        perform(segue: "toMain")
    }
    func onRecover() {
        perform(segue: "onRecover")
    }
    func toRegistration() {
        perform(segue: "toRegistration")
    }
}
