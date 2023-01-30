//
//  MGSession.swift
//
//  Created by Moinuddin Girach on 17/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

/// Session class. main purpose to create class is to make singalton object of URLSession. shaed object of URLSesion does not allow to cusomize configuration so neds to create custom URLSession oject and set configuration.
public class MGSession: NSObject, URLSessionDataDelegate, MGSessionProtocol  {
    public var bundle: Bundle = Bundle.main
    
    private static let serialQueue = DispatchQueue(label: "com.moin.girach.serial")
    
    public static let shared: MGSessionProtocol = {
        return serialQueue.sync {
            return MGSession()
        }
    }()
    
    public static var sharedSession: URLSession? {
        return shared.session
    }
    
    public var session: URLSession?
    
    private override init() {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
}
