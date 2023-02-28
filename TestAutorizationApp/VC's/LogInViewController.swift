//
//  ViewController.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import UIKit

class LogInViewController: UIViewController {
   
    var captchaKey: String?
    var token: String = ""
    //MARK: view's
    
    private lazy var nameField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "enter login"
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(named: "backTF")
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
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
    
    private lazy var captchaField: UITextField = {
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
    
    private lazy var logInButton: UIButton = {
        var button = UIButton()
        button.setTitle("LogIn", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonBG")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var captchaImageView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCaptchaImageandKey()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        tryAuth()
       let bioVC = BIOViewController()
        navigationController?.pushViewController(bioVC, animated: true)
        navigationController?.isNavigationBarHidden = true
    }
    
}

extension LogInViewController {
    func tryAuth() {
       
        guard let url = URL(string: "https://api-events.pfdo.ru/v1/auth") else { return }
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username" : nameField.text,
            "password" : passwordField.text,
            "captcha"  : ["key": captchaKey, "value": captchaField.text]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else {
                print("no data")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let loginResponce = try? decoder.decode(loginResponseBody.self, from: data) else {
                return
            }
            guard let decodedToken = loginResponce.data.accessToken else { return }
            self.token = decodedToken
        }.resume()
    }
    
    //            guard let data = data else { return}
    //                 let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    //
    //            let decoder = JSONDecoder()
    //            decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    
//    func logIn(username: String, password: String, captcha: [captchaLoginBody]) {
//        guard let url = URL(string: "https://api-events.pfdo.ru/v1/auth") else { return }
//
//        let body = loginRequestBody(username: username, password: password, captcha: captcha)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONEncoder().encode(body)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("no data")
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            guard let loginResponce = try? decoder.decode(loginResponseBody.self, from: data) else {
//                print("no response")
//                return
//            }
//            guard let token = loginResponce.data.accessToken else {
//                print("no token")
//                return
//            }
//            self.token = token
//
//        }.resume()
//
//    }
    
        func fetchCaptchaImageandKey() {
            guard let url = URL(string: "https://api-events.pfdo.ru/v1/captcha") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let captcha = try? decoder.decode(CaptchaResponse.self, from: data) else {
                    return
                }
                guard let imageData = captcha.data.imageData else {
                    return
                }
                guard let decodedData: Data = Data(base64Encoded: imageData.base64WithoutPrefix()) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.captchaImageView.image = UIImage(data: decodedData)
                }
           
            }.resume()
        }
        
    }

