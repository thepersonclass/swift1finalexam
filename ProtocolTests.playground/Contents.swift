import UIKit
import XCTest

protocol CountManagerType {

}

struct CountManager: CountManagerType {

}

struct CountManager1 {
    
}

class CountManagerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func test_countmanager_conform_to_protocol() {
        XCTAssertTrue((CountManager() as Any) is CountManagerType)
    }
    
    func test_countmanager1_conform_to_protocol() {
        XCTAssertFalse((CountManager1() as Any) is CountManagerType)
    }
}

CountManagerTests.defaultTestSuite.run()
