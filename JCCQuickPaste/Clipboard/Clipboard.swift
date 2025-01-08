//
//  Clipboard.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//


import AppKit

class Clipboard {
    typealias Hook = (ClipboardContent) -> Void

    private let pasteboard = NSPasteboard.general
    private let timerInterval = 1.0

    private var changeCount: Int
    private var hooks: [Hook]

    init() {
        changeCount = pasteboard.changeCount
        hooks = []
    }

    func onNewCopy(_ hook: @escaping Hook) {
        hooks.append(hook)
    }

    func startListening() {
        Timer.scheduledTimer(timeInterval: timerInterval,
                             target: self,
                             selector: #selector(checkForChangesInPasteboard),
                             userInfo: nil,
                            repeats: true)
    }

    func copy(_ string: String) {
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
    }

    @objc
    func checkForChangesInPasteboard() {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        
        if let attributedString = getAttribuedString() {
            
            let clipboardContent = ClipboardContent()
            clipboardContent.attributedString = attributedString
            
            for hook in hooks {
                hook(clipboardContent)
            }
            
            Task {
               await AppCenter.Cloud.save(.clipboardHistory, content: attributedString.string)
            }
        }
        
        changeCount = pasteboard.changeCount
  }
    
}


// MARK: - DEBUG
private extension Clipboard {
    
    /// 获取剪切板内容
    func getAttribuedString() -> NSAttributedString? {
        // 获取富文本（RTF）
        if let rtfData = pasteboard.data(forType: .rtf),
           let attributedString = NSAttributedString(rtf: rtfData, documentAttributes: nil) {
            return attributedString
        }
        
        // 获取富文本（RTFD）
        if let rtfdData = pasteboard.data(forType: .rtfd),
           let attributedString = NSAttributedString(rtfd: rtfdData, documentAttributes: nil) {
            return attributedString
        }

        
//        // 获取 HTML 文本
//        if let htmlData = pasteboard.data(forType: .html),
//           let attributedString = try? NSAttributedString(data: htmlData,
//                                                         options: [.documentType: NSAttributedString.DocumentType.html],
//                                                         documentAttributes: nil) {
//            return attributedString
//        }
        
        // 纯文本
        if let plainText = pasteboard.string(forType: .string) {
            let attributedString = NSAttributedString(string: plainText)
            return attributedString
        }
        
       
        return nil
    }
    
    func writeText(with rft: Data) {
        let fileURL = URL(fileURLWithPath: "/Users/leaf/Downloads/rtf_content.rtf")
        do {
           try rft.write(to: fileURL)
        } catch {
            print("\(error)")
        }
    }
}
