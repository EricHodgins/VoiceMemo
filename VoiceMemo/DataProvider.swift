//
//  DataProvider.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-21.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation

class DataProvider {
    
    let manager = CloudPersistenceManager()
    
    func performQuery(type: QueryType) {
        manager.perform(query: type.query) { (result) in
            self.processResult(result: result)
        }
    }
    
    private func processResult(result: Result<[Memo]>) {
        
    }
    
}
