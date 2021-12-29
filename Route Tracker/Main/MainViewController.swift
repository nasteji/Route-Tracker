//
//  MainViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet weak var router: MainRouter!
    
    @IBAction func showMap(_ sender: Any) {
        router.toMap(usseles: "пример")
    }
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.prepare(for: segue, sender: sender)
    }
}
