//
//  TableViewDataSource.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-22.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var results: [Memo]
    let tableView: UITableView
    
    init(results: [Memo], tableView: UITableView) {
        self.results = results
        self.tableView = tableView
        super.init()
        
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.reuseIdentifier, for: indexPath)
        
        let memo = results[indexPath.row]
        cell.textLabel?.text = memo.title
        
        return cell
    }
}

extension TableViewDataSource: DataProviderDelegate {
    
    func processUpdates(updates: [DataProviderUpdate<Memo>]) {
        tableView.beginUpdates()
        
        for (index, update) in updates.enumerated() {
            switch update {
            case .Insert(let memo):
                results.insert(memo, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        tableView.endUpdates()
    }
    
    func providerFailed(error: MemoErrorType) {
        print("Provider failed with error.")
    }
}






























