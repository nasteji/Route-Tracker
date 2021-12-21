//
//  HideViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 13.12.2021.
//

import Foundation
import UIKit

class HideViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideView), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showView), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func hideView() {
        self.view.alpha = 0
    }
    
    @objc func showView() {
        self.view.alpha = 1
    }
}
