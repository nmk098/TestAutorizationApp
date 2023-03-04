//
//  BIOViewController.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import UIKit

class BIOViewController: UIViewController {
    
    private lazy var exitButton: UIButton = {
        var button = UIButton()
        button.setTitle("LogOut", for: .normal)
        button.backgroundColor = UIColor(named: "buttonBG")
        button.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.tintColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        fetchInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AccentColor")
        view.addSubview(exitButton)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 80),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func logOutButtonTap() {
        UserDefaults.standard.removeObject(forKey: "jsonToken")
        navigationController?.popViewController(animated: true)
    }
}

extension BIOViewController {
    func fetchInfo() {
        guard let url = URL(string: "https://api-events.pfdo.ru/v1/user") else {
            print("url is not avalible")
            return
        }
        var request = URLRequest(url: url)
        
        guard let json = UserDefaults.standard.string(forKey: "jsonToken") else { return }
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(json)", forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .utility).async {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data else {
                    return }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let decodeResponse = try? decoder.decode(Bio.self, from: data) else {
                    print("cant decode")
                    return
                }
                DispatchQueue.main.async {
                    let decodedName = decodeResponse.data.profile.name
                    self?.nameLabel.text = decodedName
                }
            }.resume()
        }
    }
}

