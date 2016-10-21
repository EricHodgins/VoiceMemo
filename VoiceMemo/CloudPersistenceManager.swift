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
    case QueryFailed(description: String, userInfo: [NSObject : AnyObject])
    
    var description: String {
        switch self {
        case .SaveFailed(let description):
            return "Save Failed: \(description)"
        case .QueryFailed(let description, let userInfo):
            return "Query failed. Description: \(description), userInfo: \(userInfo.description)"
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
    
    func perform(query: CKQuery, completion: @escaping (Result<[Memo]>) -> Void) {
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard let records = records else {
                if let error = error as? NSError {
                    let persistenceError = PersistenceError.QueryFailed(description: error.localizedDescription, userInfo: error.userInfo as [NSObject : AnyObject])
                    completion(Result.Failure(persistenceError))
                } else {
                    let persistenceError = PersistenceError.InsufficientInformation
                    completion(Result.Failure(persistenceError))
                }
                
                return
            }
            
            let memos = records.flatMap { Memo(record: $0) } // flatMap makes optionals go away.
            completion(Result.Success(memos))
        }
    }
    
    func fetch(recordID: CKRecordID, completion: @escaping (Result<Memo>) -> Void) {
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            guard let record = record else {
                if let error = error as? NSError {
                    let persistenceError = PersistenceError.QueryFailed(description: error.localizedDescription, userInfo: error.userInfo as [NSObject : AnyObject])
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












































