//
//  ErrorExtension.swift
//  testTask
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 kovtuns. All rights reserved.
//

import Foundation

public enum CustomError: Error {
    case dataFailed
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataFailed:
            return "Sorry, something went wrong."
        }
    }
}
