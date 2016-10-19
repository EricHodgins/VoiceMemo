//
//  CloudPersistenceManager.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-18.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

enum PersistenceError: Error {
    case SaveFailed
    case InsufficientInformation
    case InvalidData
}


class CloudPersistenceManager {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(memo: Memo, completion: @escaping ((Result<Memo>) -> Void)) {
        let record = memo.persistableRecord
        privateDatabase.save(record) { (record, error) in
            
            guard let record = record else {
                if let _ = error {
                    let persistenceError = PersistenceError.SaveFailed
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
