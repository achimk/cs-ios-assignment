//
//  PopularListStateObservableTestCase.swift
//  CS_iOS_AssignmentTests
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
import RxSwift
@testable import CS_iOS_Assignment

class PopularListStateObservableTestCase: XCTestCase {
    
    struct StateResult: Equatable {
        let name: String
        let itemsCount: Int
        
        static func initial(itemsCount: Int) -> StateResult {
            return StateResult(
                name: ActivityStateName.initial.rawValue,
                itemsCount: itemsCount)
        }
        
        static func loading(itemsCount: Int) -> StateResult {
            return StateResult(
                name: ActivityStateName.loading.rawValue,
                itemsCount: itemsCount)
        }
        
        static func failure(itemsCount: Int) -> StateResult {
            return StateResult(
                name: ActivityStateName.failure.rawValue,
                itemsCount: itemsCount)
        }
        
        static func success(itemsCount: Int) -> StateResult {
            return StateResult(
                name: ActivityStateName.success.rawValue,
                itemsCount: itemsCount)
        }
        
        static func from(_ state: PopularListState) -> StateResult {
            return StateResult(
                name: state.activity.stringValue,
                itemsCount: state.items.count)
        }
    }
}
