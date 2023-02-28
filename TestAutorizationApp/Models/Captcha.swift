//
//  Model.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import Foundation

struct Captcha: Codable, Hashable {
    var key: String?
    var imageData: String?
}

struct CaptchaResponse: Decodable, Hashable {
    var resultCode: String
    var resultMessage: String
    var data: Captcha
}

struct CaptchaValue: Decodable, Hashable {
    var key: String
    var value: String
}
