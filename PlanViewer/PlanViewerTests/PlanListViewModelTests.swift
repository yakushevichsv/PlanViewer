//
//  PlanListViewModelTests.swift
//  PlanViewerTests
//
//  Created by syakushevich on 29.06.21.
//

import XCTest
import Combine

@testable import PlanViewer

// MARK:- PlanListViewModelTests
class PlanListViewModelTests: XCTestCase {
    var viewModel: PlanListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PlanListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldLoadIfEmpty() throws {
        XCTAssertTrue(viewModel.shouldLoad)
    }
    
    func testShouldNotLoadIfThereArePlans() throws {
        viewModel.item = [PlanModel(name: "", identifier: "", house: .init(rooms: []))]
        XCTAssertFalse(viewModel.shouldLoad)
    }
    
    func testJSONParseWithSame2RoomsSuccess() async throws {
        //"Project-3-Same-Rooms"
        guard let path = Bundle.init(for: Self.self).path(forResource: "Project-3-Same-Rooms", ofType: "json") else {
            XCTFail("No path")
            return
        }
        
        let plans = (try? await viewModel.loadPlans(paths: [path])) ?? []
        
        XCTAssert(plans.count == 1 && plans.first?.house.rooms.count == 2) // same rooms but read them as it is..
    }
    
    func testJSONParseIfNoFileThrowsFail() async throws {
        //"Project-3-Same-Rooms"
        guard let originalPath = Bundle.init(for: Self.self).path(forResource: "Project-3-Same-Rooms", ofType: "json") else {
            XCTFail("No path")
            return
        }
        
        var parts = originalPath.components(separatedBy: "/")
        parts.removeLast()
        parts.append("Fake.json")
        
        let path = parts.joined(separator: "/")
        var plans: [PlanModel]!
        do {
            plans = (try await viewModel.loadPlans(paths: [path]))
            XCTFail("should be expetions")
        } catch {
            XCTAssertNil(plans)
        }
    }
}
