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
        
        var clipboardContent = ClipboardContent()
        var isChange = false
        // 获取纯文字
        if let plainText = pasteboard.string(forType: .string) {
            clipboardContent.plainText = plainText
            isChange = true
        }

        // 获取 RTF 富文本
        if let rtfData = pasteboard.data(forType: .rtf) {
            clipboardContent.rtfData = rtfData
            isChange = true
        }
        if isChange {
            for hook in hooks {
                hook(clipboardContent)
            }
        }

        changeCount = pasteboard.changeCount
  }
}
