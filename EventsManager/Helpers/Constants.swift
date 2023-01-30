//
//  Constants.swift
//  EventManager
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

struct Constants {
    
    /// https://private-anon-b563f47a0d-tmpz.apiary-mock.com/v1/
    static var host: String {
        return "https://private-anon-b563f47a0d-tmpz.apiary-mock.com/v1/"
    }
}


struct EndpointsConstants {
    
    /// auth/token
    public static let authentication: String = {return "auth/token"}()
    
    /// events/search
    public static let eventSearch: String = {return "events/search"}()
    
    /// events/{event_id}/join
    public static let eventJoin: String = {return "events/%d/join"}()
    
    /// events/{event_id}/leave
    public static let eventLeave: String = {return "events/%d/leave"}()
}
