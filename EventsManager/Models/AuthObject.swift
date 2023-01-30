//
//  AuthObject.swift
//  EventManager
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

class AuthObject: Codable, Equatable {
    
    /// eccess token
    var accessToken: String
    
    /// token expire time interval in seconds. it gives expire time from when token has been generated.
    var expiresIn: Int
    
    /// scope
    var scope: String
    
    /// token type
    var tokenType: String
    
    /// give token generation time.
    var tokenGenerationTime: Date?
    
    /// gives true is token is not expired.
    var isValid: TokenValidity {
        var isValidToken: TokenValidity = .expired
        guard let expDate = tokenGenerationTime?.addingTimeInterval(TimeInterval(expiresIn)) else {return isValidToken}
        let currentTime = Date()
        let result = currentTime.compare(expDate)
        switch result {
        case .orderedAscending:
            isValidToken = .valid
        default:
            isValidToken = .expired
        }
        return isValidToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresIn
        case scope
        case tokenType
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        tokenGenerationTime = Date()
    }
    
    init(accessToken: String, expiresIn: Int, scope: String, tokenType: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.scope = scope
        self.tokenType = tokenType
    }
    
    static func == (lhs: AuthObject, rhs: AuthObject) -> Bool {
        return lhs.accessToken == rhs.accessToken && lhs.expiresIn == rhs.expiresIn && lhs.scope == rhs.scope && lhs.tokenType == rhs.tokenType
    }
    
}
