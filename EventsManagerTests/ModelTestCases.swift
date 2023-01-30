//
//  ModelTestCases.swift
//  EventsManagerTests
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

import XCTest
@testable import EventsManager

class ModelTestCases: XCTestCase {

    private var expectation:  XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LocalDataManager.authObject = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAuthModel() throws {
        let json = "{\"access_token\": \"e3e4db4432d6f93905f705e53a4898087920b6e71b0ffc4b5451924361c3e86b\",\"expires_in\": 3600,\"scope\": \"read\",\"token_type\": \"Bearer\"}"
        let jsonData = json.data(using: .utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        var model: AuthObject?
        do {
            model = try decoder.decode(AuthObject.self, from: jsonData!)
            XCTAssertEqual(model?.accessToken, "e3e4db4432d6f93905f705e53a4898087920b6e71b0ffc4b5451924361c3e86b")
            XCTAssertEqual(model?.expiresIn, 3600)
            XCTAssertEqual(model?.scope, "read")
            XCTAssertEqual(model?.tokenType, "Bearer")
            XCTAssertEqual(model?.isValid, TokenValidity.valid)
        } catch {
            XCTAssert(false, "Unable to create auth model")
        }
        model?.tokenGenerationTime = model?.tokenGenerationTime?.addingTimeInterval(-Double(model!.expiresIn))
        XCTAssertEqual(model?.isValid, TokenValidity.expired)
    }
    
    func testEventModel() {
        let json = "{\"id\": 119281,\"title\": \"Movie Night\",\"created-at\": -1451,\"ttl\": 7200,\"participants\": 4}"
        let jsonData = json.data(using: .utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let model = try decoder.decode(Event.self, from: jsonData!)
            XCTAssertEqual(model.id, 119281)
            XCTAssertEqual(model.createdAt, -1451)
            XCTAssertEqual(model.title, "Movie Night")
            XCTAssertEqual(model.ttl, 7200)
            XCTAssertEqual(model.participants, 4)
            XCTAssertEqual(model.isJoined, false)
        } catch {
            XCTAssert(false, "Unable to create auth model")
        }
    }
    
    func testEventInitializtion() {
        let event = Event(id: 119281, title: "Movie Night", createdAt: -1451, ttl: 7200, participants: 4)
        XCTAssertEqual(event.id, 119281)
        XCTAssertEqual(event.createdAt, -1451)
        XCTAssertEqual(event.title, "Movie Night")
        XCTAssertEqual(event.ttl, 7200)
        XCTAssertEqual(event.participants, 4)
        XCTAssertEqual(event.isJoined, false)
    }
    
    func testEventJoin() {
        let event = Event(id: 1, title: "testEvent", createdAt: 3000, ttl: 2000, participants: 4)
        expectation = expectation(description: "getEventList")
        do {
            try event.joinEvent { (success) in
                self.expectation?.fulfill()
            }
        } catch {
            switch error {
            case EventManagerError.apiKeyNotSet:
                XCTAssert(false, "invalid key")
            case EventManagerError.notAuthorized:
                XCTAssert(false, "not authorized")
            default:
                break
            }
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(event.isJoined, true)
    }
    
    func testEventLeave() {
        let event = Event(id: 1, title: "testEvent", createdAt: 3000, ttl: 2000, participants: 4)
        event.isJoined = true
        expectation = expectation(description: "getEventList")
        do {
            try event.leaveEvent { (success) in
                self.expectation?.fulfill()
            }
        } catch {
            switch error {
            case EventManagerError.apiKeyNotSet:
                XCTAssert(false, "invalid key")
            case EventManagerError.notAuthorized:
                XCTAssert(false, "not authorized")
            default:
                break
            }
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(event.isJoined, false)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
