//
//  AuthenticationManager.swift
//  EventManager
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

public enum TokenValidity {
    case invalid
    case expired
    case valid
}

public struct AuthenticationManager {
    
    var APIKey: String
    
    var isTokenValid: TokenValidity {
        var tokenValidity: TokenValidity = .invalid
        if let authObject = LocalDataManager.authObject {
            tokenValidity = authObject.isValid
        }
        return tokenValidity
    }
    
    func validateOrGenerateToken(onComplete: @escaping (Bool) -> Void) {
        switch isTokenValid {
        case .valid:
            onComplete(true)
        default:
            authenticateUser(onComplete: onComplete)
        }
    }
    
    func authenticateUser(onComplete: @escaping (Bool) -> Void) {
        let input = MGRouterAuthorizationInput(apiKey: APIKey)
        MGRouter(input: input).apiCall { (result: Result<AuthObject?, Error>) in
            switch result {
            case let .success(response):
                LocalDataManager.authObject = response
                onComplete(true)
            case let .failure(error):
                print(error)
                LocalDataManager.authObject = nil
                onComplete(false)
            }
        }
    }
    
    func checkAuthentication() throws {
        guard isTokenValid == .valid else {
            throw EventManagerError.notAuthorized
        }
    }
    
    func validateApiKey() throws {
        guard !APIKey.isEmpty else {
            throw EventManagerError.apiKeyNotSet
        }
    }
}
