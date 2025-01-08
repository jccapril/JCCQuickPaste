//
//  AppCenter.Cloud.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/8.
//

import CloudKit

enum JQRecordType: String {
    case clipboardHistory = "ClipboardHistory"
    case clipboardFavorite = "ClipboardFavorite"
}

extension AppCenter {
    enum Cloud {}
}

extension AppCenter.Cloud {
    
    static let database = CKContainer.default().privateCloudDatabase
    
    /// 保存记录
    /// - Parameters:
    ///   - recordType: 类型
    ///   - content: 剪切板
    ///   - title: 标题
    static func save(_ recordType: JQRecordType, content: String, title: String? = nil) async {
        let record = CKRecord(recordType: recordType.rawValue)
        record["content"] = content as CKRecordValue
        if let title {
            record["title"] = title
        }
        do {
            try await database.save(record)
            print("保存成功")
        } catch {
            print("保存失败：\(error)")
        }
    }
    
    
    static func query(_ recordType: JQRecordType) async {
        let query = CKQuery(recordType: recordType.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        do {
            let result = try await database.records(matching: query)
            for record in result.matchResults {
                switch record.1 {
                case .success(let record):
                    print("记录: \(record)")
                case .failure(let error):
                    print("记录获取失败: \(error.localizedDescription)")
                }
            }
        } catch {
                print("查询失败: \(error)")
        }
    }
}
