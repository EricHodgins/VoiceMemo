//
//  QueryType.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-21.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

enum QueryType {
    case All
}

extension QueryType {
    var query: CKQuery {
        switch self {
        case .All:
            let allPredicate = NSPredicate
        }
    }
}
