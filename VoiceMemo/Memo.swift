//
//  Memo.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-16.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

struct Memo {
    static var entityName = "\(Memo.self)"
    
    let id: CKRecordID?
    let title: String
    let fileURLString: String
}

extension Memo {
    var fileURL: URL {
        return URL(fileURLWithPath: fileURLString)
    }
}

extension Memo {
    var persistableRecord: CKRecord {
        let record = CKRecord(recordType: Memo.entityName)
        record.setValue(title, forKey: "title")
        
        let asset = CKAsset(fileURL: MemoRecorder.outPutURL())
        //let asset = CKAsset(fileURL: fileURL as URL)
        record.setValue(asset, forKey: "recording")
        
        return record
    }
}

extension Memo {
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else {
                return nil
        }
        
        guard let asset = record.value(forKey: "recording") as? CKAsset else {
            return nil
        }

        self.id = record.recordID
        self.title = title
        self.fileURLString = asset.fileURL.absoluteString
    }
}

extension Memo {
    var track: Data? {
        do {
            let url = URL(string: fileURLString)!
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}

// Notes:
// Choose String type as fileURLString instead of type URL.  Structs are value types.  If you declard a constant as a Struct
// you exptect it to be immutable.  If you make a member of the Struct a reference type (e.g. URL) then you can mutate that 
// struct now.
