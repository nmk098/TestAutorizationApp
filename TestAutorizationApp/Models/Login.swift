//
//  Login.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 28.02.23.
//

import Foundation

enum AuthorizationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct loginRequestBody: Codable {
    var username: String
    var password: String
    var captcha: [captchaLoginBody]
}
struct captchaLoginBody: Codable {
    var key: String?
    var value: String?
}

struct loginResponseBody: Codable {
    var resultCode: String
    var resultMessage: String
    var data: TokenResponse
}

struct TokenResponse: Codable {
    var tokenType: String?
    var expiresIn: Int
    var accessToken: String?
    var refreshToken: String?
}
