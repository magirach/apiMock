//
//  LocalDataManagerTests.swift
//  EventsManagerTests
//
//  Created by Moinuddin Girach on 04/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import XCTest
@testable import EventsManager

class LocalDataManagerTests: XCTestCase {

    private var expectation:  XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LocalDataManager.authObject = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalDataManager() throws {
        let auth = AuthObject(accessToken: "12345", expiresIn: 3600, scope: "read", tokenType: "Bearer")
        LocalDataManager.authObject = auth
        XCTAssertEqual(LocalDataManager.authObject, auth)
    }

}
