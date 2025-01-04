//
//  ClipboardDataStorage.swift
//  JCCQuickPaste
//
//  Created by 蒋晨成 on 2025/1/4.
//

import Foundation

extension Notification.Name {
    static let clipboardContentDidChange = Notification.Name("clipboardContentDidChange")
}

class ClipboardDataStorage {
    
    static let shared = ClipboardDataStorage()
    
    var dataSource: [ClipboardContent] = []
    
    func add(_ item: ClipboardContent) {
        dataSource.append(item)
    }
}
