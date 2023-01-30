//
//  EventManagerTests.swift
//  EventsManagerTests
//
//  Created by Moinuddin Girach on 04/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import XCTest
@testable import EventsManager

class EventManagerTests: XCTestCase {

    private var expectation:  XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LocalDataManager.authObject = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEventManager() throws {
        EventManager.shared.apiKey = "1234"
        XCTAssertEqual(EventManager.shared.configuration.apiKey, "1234")
        XCTAssertEqual(EventManager.shared.authManager.APIKey, "1234")
        XCTAssertEqual(EventManager.shared.apiKey, "1234")
        
        expectation = expectation(description: #function)
        
        try! EventManager.shared.authenticate { (success) in
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(EventManager.shared.authManager.isTokenValid, TokenValidity.valid)
        
        expectation = expectation(description: #function)
        try! EventManager.shared.getEvents(query: "m") { (events, error) in
            XCTAssertEqual(events.count, 14)
            XCTAssertNil(error)
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
    }
    
    func testEvnetManagerFailCases() {
        MockConfiguration.setMockFileForFailure(fileKey: "default", forKey: "MGRouterAuthorizationInput")
        expectation = expectation(description: #function)
        do {
            try EventManager.shared.authenticate { (success) in
                self.expectation?.fulfill()
            }
        } catch {
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(EventManager.shared.authManager.isTokenValid, TokenValidity.invalid)
        
    }

}
