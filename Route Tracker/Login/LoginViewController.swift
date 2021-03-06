//
//  LoginViewController.swift
//  Route Tracker
//
//  Created by Анастасия Живаева on 09.12.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: HideViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var router: LoginRouter!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        guard loginView.text != "",
              passwordView.text != ""
        else {
            alert(title: "Поля не заполнены", message: "")
            return
        }
        guard let realm = try? Realm() else { return }
        if let user = realm.object(ofType: User.self, forPrimaryKey: loginView.text),
           passwordView.text == user.password {
            UserDefaults.standard.set(true, forKey: "isLogin")
            router.toMain()
        } else {
            alert(title: "Неправильный логин или пароль", message: "")
        }
    }
    
    @IBAction func recovery(_ sender: Any) {
        router.onRecover()
    }
    @IBAction func registration(_ sender: Any) {
        router.toRegistration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        passwordView.delegate = self
        
        loginView.autocorrectionType = .no
        passwordView.autocorrectionType = .no
        passwordView.isSecureTextEntry = true
        
    }
    
    func configureLoginBindings() {
        Observable
            .combineLatest(loginView.rx.text, passwordView.rx.text).map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
            }
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
