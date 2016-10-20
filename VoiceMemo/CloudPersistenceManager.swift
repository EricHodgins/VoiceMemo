//
//  CloudPersistenceManager.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-18.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

enum PersistenceError: MemoErrorType {
    case SaveFailed(description: String)
    case InsufficientInformation
    case InvalidData
    
    var description: String {
        switch self {
        case .SaveFailed(let description):
            return "Save Failed: \(description)"
        default:
            return "self"
        }
    }
}


class CloudPersistenceManager {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(memo: Memo, completion: @escaping ((Result<Memo>) -> Void)) {
        let record = memo.persistableRecord
        privateDatabase.save(record) { (record, error) in
            
            guard let record = record else {
                if let error = error {
                    let persistenceError = PersistenceError.SaveFailed(description: error.localizedDescription)
                    completion(Result.Failure(persistenceError))
                } else {
                    let persistenceError = PersistenceError.InsufficientInformation
                    completion(Result.Failure(persistenceError))
                }
                
                return
            }
            
            guard let memo = Memo(record: record) else {
                let error = PersistenceError.InvalidData
                completion(Result.Failure(error))
                return
            }
            
            completion(Result.Success(memo))
            
        }
    }
}
