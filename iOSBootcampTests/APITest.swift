//
//  APITest.swift
//  iOSBootcampTests
//
//  Created by esb23471 on 2023/8/9.
//

import XCTest
@testable import iOSBootcamp

final class APITest: XCTestCase {

    //測試API運作
    func testFetchItems() {
            
        //呼叫
        let searchController = SearchController.shared
            
        //執行
        let expectation = XCTestExpectation(description: "Fetch Items")
        let query: [String: String] = [
            "term": "Taylor Swift",
            "media": "music"
        ]
            
        //驗證
        searchController.fetchItems(matching: query) { result in
            switch result {
            case .success(let searchItems):
                XCTAssertNotNil(searchItems)
                XCTAssertFalse(searchItems.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 10.0) // 等待異步操作完成
    }
    
    //效能測試
    func testPerformance() {
        
        let query: [String: String] = [
            "term": "Taylor Swift",
            "media": "music"
        ]
        
        self .measure {
            
            SearchController.shared.fetchItems(matching: query) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    XCTFail("Failed with error \(error)")
                }
            }
            
        }
    }
    
    //邊界條件測試
    //空值測試
    func testFetchItemsWithEmptyQuery() {
        let expectation = self.expectation(description: "Fetch items with empty query")
        
        SearchController.shared.fetchItems(matching: [:]) { result in
            switch result {
            case .success(_) :
                XCTFail("Should have failed with an error")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Invalid response error 0.)", "Error message mismatch")
                expectation.fulfill()
            }
            
            
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation error \(error)")
            }
        }
        
    }
    
    

}
