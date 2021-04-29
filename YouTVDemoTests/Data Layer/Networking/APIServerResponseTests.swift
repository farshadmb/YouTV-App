//
//  APIServerResponseTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/30/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import XCTest
import Foundation

@testable import YouTVDemo

// swiftlint:disable all
class APIServerResponseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testSuccessAPIResponse() {
        let data = """
           [
                "status",
                "totalResults",
                "articles"
            ]
        """.data(using: .utf8)!
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssert(response.status == .success , "APIServerResponse data was not able to decode.")
            XCTAssertNotNil(response.data, "APIServerResponse data was not able to decode.")

            print("Decoded Objc ", response)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }
    
    func testFailureAPIResponse() throws {
        let data = """
            {
                "status_code": 7,
                "status_message": "Invalid API key: You must be granted a valid key.",
                "success": false
            }
            """.data(using: .utf8)!
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssertNil(response, "Responsed was decoded successfully. detail: \(response)")
        } catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }

    }


    func testSuccessDecoding() {
        let data = NetworkMockingDataFactory.createSimpleJSONData()
        do {
            let response = try JSONDecoder().decode(APIServerResponse<APIPostModel>.self, from: data)
            XCTAssert(response.status == .success , "APIServerResponse data was not able to decode.")
            XCTAssertNotNil(response, "APIServerResponse data was not able to decode.")

            print("Decoded Objc ", response)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }

    func testFailureDecoding() {
        let data = """
                   {
                       "success": false,
                       "message": "Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key."
                   }
                   """.data(using: .utf8)!

        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssertNil(response, "Responsed was decoded successfully. detail: \(response)")
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }
    }

}
