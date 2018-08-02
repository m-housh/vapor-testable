import XCTest

import VaporTestableTests

var tests = [XCTestCaseEntry]()
tests += VaporTestableTests.allTests()
XCTMain(tests)