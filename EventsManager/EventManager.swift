//
//  EventManager.swift
//  MGRouter
//
//  Created by Moinuddin Girach on 03/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

enum EventManagerError: Error {
    case apiKeyNotSet
    case notAuthorized
}

public class EventManager: NSObject {
    
    public var apiKey: String {
        set {
            configuration.apiKey = newValue
            authManager.APIKey = newValue
        }
        get {
            return configuration.apiKey
        }
    }
    
    var configuration: Configuration
    var authManager: AuthenticationManager = AuthenticationManager(APIKey: "")

    public static let shared: EventManager = {
        return EventManager()
    }()
    
    private override init() {
        configuration = Configuration(apiKey: "")
    }
    
    public func authenticate(onComplete: @escaping (Bool) -> Void) throws {
        
        try authManager.validateApiKey()
        switch authManager.isTokenValid {
        case .valid:
            onComplete(true)
        default:
            authManager.authenticateUser(onComplete: onComplete)
        }
    }
    
    public func getEvents(query: String, onComplete: @escaping ([Event], Error?) -> Void) throws {
        
        try authManager.validateApiKey()
        try authManager.checkAuthentication()
        
        let input = MGRouterSearchEventsInput(searchQuery: query)
        MGRouter(input: input).call { (result: Result<[Event]?, Error>) in
            switch result {
            case let .success(response):
                onComplete(response ?? [], nil)
            case let .failure(error):
                onComplete([], error)
            }
        }
    }
}

struct Configuration {
    public var apiKey: String = ""
}
