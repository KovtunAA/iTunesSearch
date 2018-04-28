//
//  testListInteractorTests.swift
//  testTaskTests
//
//  Created by Mitya_Potemkin on 4/27/18.
//  Copyright © 2018 kovtuns. All rights reserved.
//

import XCTest
@testable import testTask

class testListInteractorTests: XCTestCase {

    var instance: ListInteractor!

    var correctVideosArray: [Video]!
    let emptyVideosArray: [Video] = []
    var initialVideosArray: [Video]!
    let excludedKey = "Docs"


    override func setUp() {
        super.setUp()

        self.correctVideosArray = [
            Video(artworkUrl100: "test", trackName: "test", trackCensoredName: "test"),
            Video(artworkUrl100: "test1", trackName: "test1", trackCensoredName: "test1"),
            Video(artworkUrl100: "test2", trackName: "test2", trackCensoredName: "test2")
        ]
        self.initialVideosArray = [
            Video(artworkUrl100: "test", trackName: "test", trackCensoredName: "test"),
            Video(artworkUrl100: "test0", trackName: "test0", trackCensoredName: excludedKey),
            Video(artworkUrl100: "test1", trackName: "test1", trackCensoredName: "test1"),
            Video(artworkUrl100: "test2", trackName: "test2", trackCensoredName: "test2"),
            Video(artworkUrl100: "test3", trackName: "test3", trackCensoredName: excludedKey)
        ]
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testFilteringVideos_CompareCount() {
        self.instance = ListInteractor()

        let result = self.instance.filteringVideos(videos: self.initialVideosArray, excludeKey: excludedKey)

        XCTAssertEqual(self.correctVideosArray.count, result.count, file: "testListInteractorTests.swift", line: 43)
    }

    func testFilteringVideos_EmptyArray() {
        self.instance = ListInteractor()

        let result = self.instance.filteringVideos(videos: self.emptyVideosArray, excludeKey: excludedKey)

        XCTAssertTrue(result.isEmpty, file: "testListInteractorTests.swift", line: 51)
    }

    func testFilteringVideo_CompareArrays() {
        self.instance = ListInteractor()

        let result = self.instance.filteringVideos(videos: self.initialVideosArray, excludeKey: excludedKey)

        XCTAssertEqual(self.correctVideosArray, result, file: "testListInteractorTests.swift", line: 59)
    }

    func testFilteringVideos_EmptyExcludeKey() {
        self.instance = ListInteractor()

        let result = self.instance.filteringVideos(videos: self.initialVideosArray, excludeKey: "")

        XCTAssertEqual(self.initialVideosArray, result, file: "testListInteractorTests.swift", line: 67)
    }
}
