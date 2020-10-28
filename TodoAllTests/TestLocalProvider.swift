//
//  TestLocalProvider.swift
//  TodoAllTests
//
//  Created by Franklin Cruz on 27-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import XCTest
import Combine
@testable import TodoAll

class TestLocalProvider: XCTestCase {
    
    struct DummyData: Identifiable, Codable {
        var id: Int
        var title: String
    }
    
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        UserDefaults.standard.removeObject(forKey: String(describing: DummyData.self))
        LocalProvider.registerStoreName(forType: DummyData.self)
        cancellables = []
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: String(describing: DummyData.self))
    }

    func testCreateItem() throws {
        let expectation = XCTestExpectation(description: "Store a value with a Local Store provider")
            
        let provider = LocalProvider()
        let val = DummyData(id: 1, title: "My title")
        provider.create(val).sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data) in
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.id, val.id)
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testListItems() throws {
        let expectation = XCTestExpectation(description: "Read all the stored values")
            
        let provider = LocalProvider()
        provider.create(DummyData(id: 1, title: "My title"))
            .flatMap({ _ in
                provider.create(DummyData(id: 2, title: "My title 2"))
            })
            .flatMap({ _ -> Future<[DummyData], ServiceError> in provider.list() })
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { data in
            XCTAssertNotNil(data)
            XCTAssertEqual(data.count, 2)
            XCTAssertNotNil(data.first)
            XCTAssertNotNil(data.last)
            XCTAssertEqual(data.first?.id, 1)
            XCTAssertEqual(data.last?.id, 2)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEmptyList() throws {
        let expectation = XCTestExpectation(description: "Read store when no value have been saved")
            
        let provider = LocalProvider()
        provider.list()
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data: [DummyData]) in
            XCTAssertNotNil(data)
            XCTAssertEqual(data.count, 0)
            XCTAssertNil(data.first)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetItem() throws {
        let expectation = XCTestExpectation(description: "Get an item by id")
            
        let provider = LocalProvider()
        let val = DummyData(id: 1, title: "My title")
        provider.create(val)
            .flatMap({_ -> Future<DummyData?, ServiceError> in
                provider.get(byId: 1)
            })
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data) in
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.id, val.id)
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetItemNotCreated() throws {
        let expectation = XCTestExpectation(description: "Get an item that does not exists")
            
        let provider = LocalProvider()
        provider.get(byId: 1)
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data: DummyData?) in
            XCTAssertNil(data)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateItem() throws {
        let expectation = XCTestExpectation(description: "Update an item by id")
            
        let provider = LocalProvider()
        let val = DummyData(id: 1, title: "My title")
        provider.create(val)
            .flatMap({_ -> Future<DummyData?, ServiceError> in
                let modified = DummyData(id: 1, title: "New Title")
                return provider.update(modified)
            })
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data) in
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.id, val.id)
            XCTAssertEqual(data?.title, "New Title")
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteItem() throws {
        let expectation = XCTestExpectation(description: "Delete an item then try to get it")
            
        let provider = LocalProvider()
        let val = DummyData(id: 1, title: "My title")
        provider.create(val)
            .flatMap({ _ -> Future<DummyData?, ServiceError> in
                provider.delete(byId: 1)
            })
            .flatMap({_ -> Future<DummyData?, ServiceError> in
                provider.get(byId: 1)
            })
            .sink { completion in
            switch completion {
            case .finished:
                print("OK")
            case .failure(let e):
                XCTFail("Unexpected failure result \(e)")
            }
        } receiveValue: { (data) in
            XCTAssertNil(data)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
