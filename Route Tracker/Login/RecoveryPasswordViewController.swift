//
//  RecoveryPasswordViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import UIKit
import RealmSwift

final class RecoveryPasswordViewController: HideViewController {
    
    @IBOutlet weak var loginView: UITextField!
    
    private var password: String = ""
    
    @IBAction func recovery(_ sender: Any) {
        guard loginView.text != ""
        else {
            alert(title: "Введите логин", message: "")
            return
        }
        guard let realm = try? Realm() else { return }
        if let user = realm.object(ofType: User.self, forPrimaryKey: loginView.text) {
            password = user.password
            showPassword()
        } else {
            alert(title: "Логин не найден", message: "")
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.autocorrectionType = .no
    }
    
    private func showPassword() {
        alert(title: "Пароль", message: password)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
