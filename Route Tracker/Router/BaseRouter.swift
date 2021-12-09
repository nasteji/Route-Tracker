//
//  BaseRouter.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation
import UIKit

class BaseRouter: NSObject {
    @IBOutlet weak var controller: UIViewController!
    
    func perform<Controller: UIViewController>( segue: String,
                                                performAction: ((Controller) -> Void)? = nil) {
        let performAction = performAction.map { action in
            { (controller: UIViewController) in
                guard let controller = controller as? Controller
                else {
                    print(controller)
                    assertionFailure("Ожидался \(Controller.self)")
                    return
                }
                action(controller)
            }
        }
        controller?.performSegue(withIdentifier: segue, sender: performAction)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let action = sender as? ((UIViewController) -> Void) else { return }
        action(segue.destination)
    }
}
