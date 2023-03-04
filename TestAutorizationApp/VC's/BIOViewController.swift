//
//  BIOViewController.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import UIKit

class BIOViewController: UIViewController {
    
    lazy var exitButton: UIButton = {
        var button = UIButton()
        button.setTitle("LogOut", for: .normal)
        button.backgroundColor = UIColor(named: "buttonBG")
        button.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameLabel: UILabel = {
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


