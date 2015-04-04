//
//  EchoTests.swift
//  EchoTests
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit
import XCTest


class MusicCollectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testJSON(){

        let artists = ["andrei", "hansa", "dang"]
        let albums = ["andrei": ["benim ol", "pazar kahvaltisi"], "dang":["i'm gay"]]
        let musc = MusicCollection(json:"sfsf")
    
    }
    
}
//
//  MusicCollectionTests.swift
//  Echo
//
//  Created by aivanov on 04.04.15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import Foundation
