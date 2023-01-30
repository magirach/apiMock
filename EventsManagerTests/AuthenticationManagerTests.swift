//
//  AuthenticationManagerTests.swift
//  EventsManagerTests
//
//  Created by Moinuddin Girach on 04/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import XCTest
@testable import EventsManager

class AuthenticationManagerTests: XCTestCase {

    private var expectation:  XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LocalDataManager.authObject = nil
        MGRouter.session = MGMockSession.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testErrors() throws {
        
        let manager = AuthenticationManager(APIKey: "")
        XCTAssertEqual(manager.isTokenValid, TokenValidity.invalid)
        
        do {
            try manager.checkAuthentication()
            XCTAssert(false, "should throw error")
        } catch {
            XCTAssertEqual(error as! EventManagerError, EventManagerError.notAuthorized)
        }
        
        do {
            try manager.validateApiKey()
            XCTAssert(false, "should throw error")
        } catch {
            XCTAssertEqual(error as! EventManagerError, EventManagerError.apiKeyNotSet)
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAuthentication() throws {
        let manager = AuthenticationManager(APIKey: "1234")
        expectation = expectation(description: "testAuthentication")
        manager.authenticateUser { (success) in
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(manager.isTokenValid, TokenValidity.valid)
        
        do {
            try manager.checkAuthentication()
            XCTAssert(true, "should throw error")
        } catch {
            XCTAssertEqual(error as! EventManagerError, EventManagerError.notAuthorized)
        }
        
        do {
            try manager.validateApiKey()
            XCTAssert(true, "should throw error")
        } catch {
            XCTAssertEqual(error as! EventManagerError, EventManagerError.apiKeyNotSet)
        }
    }
    
    func testValidateOrGenetateToken() throws {
        let manager = AuthenticationManager(APIKey: "1234")
        expectation = expectation(description: "testValidateOrGenetateToken")
        manager.validateOrGenerateToken { (success) in
            self.expectation?.fulfill()
        }
        wait(for: [expectation!], timeout: 2)
        XCTAssertEqual(manager.isTokenValid, TokenValidity.valid)
    }
}
