//
//  Result.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-19.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation

protocol MemoErrorType: Error {
    var description: String { get }
}

enum Result<T> {
    case Success(T)
    case Failure(MemoErrorType)
}
