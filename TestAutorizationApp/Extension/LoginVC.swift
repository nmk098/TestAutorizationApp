//
//  LoginVC.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 04.03.23.
//

import Foundation
import UIKit

extension LogInViewController {
    
    func tryAuth(completion: @escaping(Result<String, ResponseError>) -> Void) {
       
        guard let url = URL(string: "https://api-events.pfdo.ru/v1/auth") else { return }
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let userName = nameField.text else { return }
        guard let password = passwordField.text else { return }
        
        let body: [String: Any] = [
            "username" : userName,
            "password" : password,
            "captcha"  : ["key": captchaKey, "value": captchaField.text]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription )
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ResponseError.badResponse(response)))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
   
            guard let loginResponce = try? decoder.decode(LoginResponseBody.self, from: data) else { return }
            
            guard let decodedToken = loginResponce.data.accessToken else { return }
            self?.token = decodedToken
            completion(.success(decodedToken))
        }.resume()
    }
    
        func fetchCaptchaImageandKey() {
            guard let url = URL(string: "https://api-events.pfdo.ru/v1/captcha") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            DispatchQueue.global(qos: .utility).async {
                URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                    
                    guard let decodedKey = captcha.data.key else {
                        print("no key")
                        return
                    }
                    
                    self?.captchaKey = decodedKey
                    
                    guard let decodedData: Data = Data(base64Encoded: imageData.base64WithoutPrefix()) else {
                        return
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.captchaImageView.image = UIImage(data: decodedData)
                    }
                }.resume()
            }
         
        }
    }
