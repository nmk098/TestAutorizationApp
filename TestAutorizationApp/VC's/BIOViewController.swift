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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 80),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @objc
    func logOutButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}
