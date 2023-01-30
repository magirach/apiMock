//
//  Event.swift
//  EventManager
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

public class Event: Codable {
    public var id: Int
    public var title: String
    public var createdAt: Int
    public var ttl: Int
    public var participants: Int
    public var isJoined: Bool = false
    public var createdTime: Date?
    public var expiryTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case createdAt = "created-at"
        case ttl
        case participants
    }
    
    public init(id: Int, title: String, createdAt: Int, ttl: Int, participants: Int) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.ttl = ttl
        self.participants = participants
        
        setOtherProperties()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.ttl = try container.decode(Int.self, forKey: .ttl)
        self.participants = try container.decode(Int.self, forKey: .participants)
        
        setOtherProperties()
    }
    
    func setOtherProperties() {
        let date = Date()
        createdTime = date.addingTimeInterval(TimeInterval(createdAt))
        expiryTime = date.addingTimeInterval(TimeInterval(ttl))
    }
    
    public func joinEvent(onComplete: @escaping (Bool) -> Void) throws {
        let input = MGRouterJoinEventInput(eventId: id)
        MGRouter(input: input).call { (result: Result<Data?, Error>) in
            switch result {
            case .success(_):
                self.isJoined = true
                onComplete(true)
            case .failure(_):
                onComplete(false)
            }
        }
    }
    
    public func leaveEvent(onComplete: @escaping (Bool) -> Void) throws {
                let input = MGRouterLeaveEventInput(eventId: id)
                MGRouter(input: input).call { (result: Result<Data?, Error>) in
                    switch result {
                    case .success(_):
                        self.isJoined = false
                        onComplete(true)
                    case let .failure(error):
                        print(error)
                        onComplete(false)
                    }
                }
    }
}
