//
//  Launch.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import Foundation
import UIKit

class Launch: UIViewController {
    @IBOutlet weak var router: LaunchRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLogin") {
            router.toMain() }
        else {
            router.toAuth()
        }
    }
    
}
