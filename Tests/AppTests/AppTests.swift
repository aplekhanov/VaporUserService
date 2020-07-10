@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    let rootPath = "/*/users/"
    
    func testHealth() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        try app.test(.GET, rootPath.appending("health")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "OK")
        }
    }
    
}
