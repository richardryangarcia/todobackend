import XCTest

import todoTests

var tests = [XCTestCaseEntry]()
tests += todoTests.allTests()
XCTMain(tests)
