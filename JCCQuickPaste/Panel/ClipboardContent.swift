//
//  ClipboardContent.swift
//  JCCQuickPaste
//
//  Created by 蒋晨成 on 2025/1/4.
//

import Foundation

struct ClipboardContent {
    var plainText: String?
    var rtfData: Data?
    var htmlData: Data?
    
    var attributedString: NSAttributedString {
        let result = NSMutableAttributedString()
        
        // 拼接纯文本
        if let plainText {
            let plainTextAttributed = NSAttributedString(string: plainText)
            result.append(plainTextAttributed)
        }
        
        // 拼接 RTF 富文本
        if let rtfData {

            if let rtfAttributed = NSAttributedString(rtf: rtfData, documentAttributes: nil) {
                result.append(rtfAttributed)
            }
        }
        
        // 拼接 HTML 富文本
        if let htmlData {
            if let htmlAttributed = NSAttributedString(html: htmlData, documentAttributes: nil) {
                result.append(htmlAttributed)
            }
        }
        
        return result
    }
}
