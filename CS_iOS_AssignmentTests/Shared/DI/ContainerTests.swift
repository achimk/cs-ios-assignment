//
//  ContainerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

final class ContainerTests: XCTestCase {
    
    final class DependencyObject { }
    
    func test_registerObjectInContainer_shouldReciveValidObject() {
        // given
        let dependency = DependencyObject()
        let container = Container()
        container.register(DependencyObject.self) { _ in dependency }
        
        //when
        let result = container.resolve(DependencyObject.self)
        
        // then
        XCTAssertTrue(dependency === result)
    }
    
    func test_unregisteredObjectInContainer_shouldReceiveInvalidObject() {
        // given
        let dependency = DependencyObject()
        let invalid = DependencyObject()
        let container = Container()
        
        //when
        let result = container.resolve(DependencyObject.self, otherwise: { invalid })
        
        // then
        XCTAssertTrue(dependency !== result)
        XCTAssertTrue(invalid === result)
    }
}
