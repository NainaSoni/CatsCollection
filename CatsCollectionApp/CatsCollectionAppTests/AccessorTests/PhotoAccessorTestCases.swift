//
//  PhotoAccessorTestCases.swift
//  CatsCollectionAppTests
//
//  Created by Ravi R Dixit on 11/28/19.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import XCTest

@testable import CatsCollectionApp
class PhotoAccessorTestCases: XCTestCase {

    let photoAccessor = AccessorFactory.createPhotoAccessor()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_getPhotos_With_Good_Request_Returns_PhotoCollection(){

        //ARRANGE
        let request = PhotoRequest(limit:"10",order:"1",category_ids:String())
        let expectation = XCTestExpectation(description: "Data received from server")

        //ACT
        photoAccessor.getPhotos(request: request) { (result) in
            //ASSERT
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.count == 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_getPhotos_With_Bad_Request_Returns_EmptyCollection(){

        //ARRANGE
        let request = PhotoRequest(limit:"",order:"",category_ids:"invalidCategory")
        let expectation = XCTestExpectation(description: "Data received from server")

        //ACT
        photoAccessor.getPhotos(request: request) { (result) in
            //ASSERT
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.count == 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getPhotos_With_Hats_Category_Returns_PhotoCollection(){

        //ARRANGE
        let request = PhotoRequest(limit:"10",order:"1",category_ids:PhotoCategory.hats.rawValue)
        let expectation = XCTestExpectation(description: "Data received from server")

        //ACT
        photoAccessor.getPhotos(request: request) { (result) in
            //ASSERT
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.count == 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
