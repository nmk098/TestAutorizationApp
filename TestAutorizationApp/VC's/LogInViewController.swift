//
//  ViewController.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import UIKit

enum ResponseError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}

class LogInViewController: UIViewController {
    
    var captchaKey: String?
    var token: String = ""
    var errorString: String?
    
    //MARK: view's
    lazy var nameField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "enter login"
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "backTF")
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "enter password"
        textField.font = .systemFont(ofSize: 18, weight: .light)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "backTF")
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var captchaField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "enter captcha"
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "backTF")
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var logInButton: UIButton = {
        var button = UIButton()
        button.setTitle("LogIn", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonBG")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var captchaImageView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCaptchaImageandKey()
        nameField.text = ""
        passwordField.text = ""
        captchaField.text = ""
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "jsonToken")?.isEmpty == false {
            DispatchQueue.main.async {
                let biovc = BIOViewController()
                self.navigationController?.pushViewController(biovc, animated: false)
                self.navigationController?.isNavigationBarHidden = true
            }
        } else {
            
        }
        
        view.backgroundColor = UIColor(named: "AccentColor")
        
        view.addSubview(nameField)
        view.addSubview(passwordField)
        view.addSubview(captchaField)
        view.addSubview(logInButton)
        view.addSubview(captchaImageView)
        
        //MARK: Constraints for view's:
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameField.heightAnchor.constraint(equalToConstant: 60),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalToConstant: 60),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            captchaField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            captchaField.heightAnchor.constraint(equalToConstant: 60),
            captchaField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            captchaField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: captchaField.bottomAnchor, constant: 40),
            logInButton.widthAnchor.constraint(equalToConstant: 80),
            logInButton.heightAnchor.constraint(equalToConstant: 40),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            captchaImageView.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 80),
            captchaImageView.widthAnchor.constraint(equalToConstant: 300),
            captchaImageView.heightAnchor.constraint(equalToConstant: 150),
            captchaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    func logInButtonTap() {
        tryAuth { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedToken):
                    UserDefaults.standard.set(decodedToken, forKey: "jsonToken")
                    
                    let bioVC = BIOViewController()
                    self.navigationController?.pushViewController(bioVC, animated: true)
                    self.navigationController?.isNavigationBarHidden = true
                    
                case .failure(let error):
                    
                    let alertController = UIAlertController(title: "Authorization Error",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(action)
                    self.present(alertController, animated: true)
                    
                }
            }
        }
    }
}


