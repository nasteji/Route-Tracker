//
//  RegistrationRouter.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation

final class RegistrationRouter: BaseRouter {
    func toMain() {
        perform(segue: "toMain")
    }
}
