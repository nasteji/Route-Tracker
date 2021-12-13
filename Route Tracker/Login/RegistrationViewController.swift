//
//  RegistrationViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import UIKit
import RealmSwift

class RegistrationViewController: HideViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var router: RegistrationRouter!
    
    @IBAction func registration(_ sender: Any) {
        guard loginTextField.text != "",
              passwordTextField.text != ""
        else {
            alert(title: "Введите логин и пароль", message: "")
            return
        }
        let newUser = User()
        newUser.login = loginTextField.text ?? ""
        newUser.password = passwordTextField.text ?? ""

        do {
            let realm = try Realm()
            guard realm.object(ofType: User.self, forPrimaryKey: loginTextField.text) == nil
            else {
                try! realm.write {
                    realm.add(newUser, update: .modified)
                }
                alert(title: "Этот логин уже существует", message: "Пароль изменен, хоть это и не логично")
                return
            }
            realm.beginWrite()
            realm.add(newUser)
            try realm.commitWrite()
        } catch {
            print(error)
        }
        router.toMain()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
