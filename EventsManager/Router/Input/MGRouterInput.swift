//
//  MGRouterInput.swift
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

public enum RouterMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol MGRouterInputProtocol: class {
    var host: String {get set}
    var endpoint: String {get set}
    var body: Data? {get set}
    var headers: [String: String] {get set}
    var timeout: Int {get set}
    var method: RouterMethod {get set}
    var cacheResponse: Bool {get set}
}

public protocol DataConvertable {
    var data:Data? {get}
}

open class MGRouterInput: MGRouterInputProtocol {
    
    public var host: String = Constants.host
    
    /// api endpoint
    public var endpoint: String
    
    /// request body
    public var body: Data?
    
    /// request headers
    public var headers: [String : String] = [:]
    
    /// timeout interval
    public var timeout: Int
    
    /// HttpMethod
    public var method: RouterMethod
    
    /// true if responce needs to be cached
    public var cacheResponse: Bool = false
        
    /// initialize router input
    /// - Parameters:
    ///   - endpoint: enpoint string
    ///   - urlParams: url query params
    ///   - body: request body data in case of post or put methods
    ///   - method: Http request method
    ///   - timeout: response time out
    ///   - arguments: url parameters
    public init(endpoint: String, urlParams: [String: Any] = [:], body: DataConvertable? = nil, method: RouterMethod = .get, timeout: Int = 30 , arguments: [CVarArg] = []) {
        self.body = body?.data
        self.timeout = timeout
        self.method = method
        
        var endpointWitArgs = endpoint
        if !arguments.isEmpty {
            endpointWitArgs = String(format: endpoint, arguments: arguments)
        }
        
        if urlParams.isEmpty {
            self.endpoint = endpointWitArgs
        } else {
            var urlc = URLComponents()
            urlc.queryItems = [URLQueryItem]()
            for (key, value) in urlParams {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlc.queryItems!.append(queryItem)
            }
            self.endpoint = "\(endpointWitArgs)?\(urlc.percentEncodedQuery ?? "")"
        }
    }
}

class MGRouterAuthorizationInput: MGRouterInput {
    init(apiKey: String) {
        let endpoint = EndpointsConstants.authentication
        super.init(endpoint: endpoint)
        headers["Authorization"] = apiKey
    }
}

class MGRouterSearchEventsInput: MGRouterInput {
    init(searchQuery: String) {
        let endpoint = EndpointsConstants.eventSearch
        super.init(endpoint: endpoint, urlParams: ["q":searchQuery])
    }
}

class MGRouterJoinEventInput: MGRouterInput {
    init(eventId: Int) {
        let endpoint = String(format: EndpointsConstants.eventJoin, eventId)
        super.init(endpoint: endpoint)
    }
}

class MGRouterLeaveEventInput: MGRouterInput {
    init(eventId: Int) {
        let endpoint = String(format: EndpointsConstants.eventLeave, eventId)
        super.init(endpoint: endpoint)
    }
}
