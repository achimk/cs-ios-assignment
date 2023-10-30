//
//  ResponseResult.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

public enum ResponseResult<T> {
    case valid(T)
    case invalid(HTTPURLResponse, Data)
}
