import XCTest
import Vapor
@testable import VaporTestable

struct TestContent: Content {
    let value: String
}


final class VaporTestableTests: XCTestCase, VaporTestable {
    
    var app: Application!
    
    func routes(_ router: Router) throws {
        router.get("test") { req in
            return TestContent(value: "Hello, world!")
        }
        
        router.post("test") { req in
            return try req.content.decode(TestContent.self)
        }
    }
    
    override func setUp() {
        perform {
            //app = try! MyTestable().makeApplication()
            app = try! makeApplication()
        }
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        perform {
            
            let test = try app.getResponse(to: "test", decodeTo: TestContent.self)
            XCTAssertEqual(test.value, "Hello, world!")
            
            let two = try app.sendRequest(to: "test", method: .GET)
            XCTAssertEqual(two.http.status.code, 200)
        }
    }
    
    func testPost() {
        perform {
            let content = TestContent(value: "post")
            let resp = try app.sendRequest(to: "test", method: .POST, headers: ["Content-Type": "application/json"], body: content)
            
            XCTAssertEqual(resp.http.status.code, 200)
        }
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
