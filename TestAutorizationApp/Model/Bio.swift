//
//  Bio.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 28.02.23.
//

import Foundation


struct Bio: Codable {
    var resultCode: String
    var resultMessage: String
    var data: DataProfile
}

struct DataProfile: Codable {
    var profile: Profile
}


struct Profile: Codable {
    var name: String
}
