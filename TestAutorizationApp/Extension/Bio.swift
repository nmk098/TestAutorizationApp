//
//  Bio.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 04.03.23.
//

import Foundation
import UIKit

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

