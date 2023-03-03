//
//  Extension.swift
//  TestAutorizationApp
//
//  Created by Никита Курюмов on 27.02.23.
//

import Foundation
import UIKit

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func base64WithoutPrefix() -> String {
        guard let firstCommaIndex = self.firstIndex(of: ",") else { return "" }
        var str = self
        str.removeSubrange(self.startIndex...firstCommaIndex)
        return str
    }
}




