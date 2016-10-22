//
//  DataProvider.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-21.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

protocol DataProviderDelegate: class {
    func processUpdates(updates: [DataProviderUpdate<Memo>])
    func providerFailed(error: MemoErrorType)
}

enum DataProviderUpdate<T> {
    case Insert(T)
}

class DataProvider {
    
    let manager = CloudPersistenceManager()
    var updates = [DataProviderUpdate<Memo>]()
    
    private weak var delegate: DataProviderDelegate?
    
    func performQuery(type: QueryType) {
        manager.perform(query: type.query) { (result) in
            self.processResult(result: result)
        }
    }
    
    func fetch(recordID: CKRecordID) {
        manager.fetch(recordID: recordID) { (result) in
            self.processResult(result: result)
        }
    }
    
    func save(memo: Memo) {
        manager.save(memo: memo) { (result) in
            self.processResult(result: result)
        }
    }
    
    private func processResult(result: Result<[Memo]>) {
        DispatchQueue.main.async {
            switch result {
            case .Success(let memos):
                self.updates = memos.map { DataProviderUpdate.Insert($0) }
                self.delegate?.processUpdates(updates: self.updates)
            case .Failure(let error):
                self.delegate?.providerFailed(error: error)
            }
        }
    }
    
    private func processResult(result: Result<Memo>) {
        DispatchQueue.main.async {
            switch result {
            case .Success(let memo):
                self.updates = [DataProviderUpdate.Insert(memo)]
                self.delegate?.processUpdates(updates: self.updates)
            case .Failure(let error):
                self.delegate?.providerFailed(error: error)
            }
        }
    }
    
}




















