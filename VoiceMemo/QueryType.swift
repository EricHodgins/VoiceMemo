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
            let allPredicate = NSPredicate(value: true) // just evaluate to true every time
            let query = CKQuery(recordType: Memo.entityName, predicate: allPredicate)
            query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            return query
        }
    }
}
