//
//  ClipboardItem.swift
//  JCCQuickPaste
//
//  Created by 蒋晨成 on 2025/1/4.
//

import Cocoa

class ClipboardItem: NSCollectionViewItem {
    
    @IBOutlet weak var textCountBGView: NSView!
    
    @IBOutlet weak var textLabel: NSTextField!
    
    @IBOutlet weak var textCountLabel: NSTextField!
    
    
    var content: ClipboardContent? {
        didSet {
            guard let content else { return }
            if let attributedString = content.attributedString {
                textLabel.attributedStringValue = attributedString
                textCountLabel.stringValue = "\(attributedString.length)个字符"
            }
            if content.isSelected {
                view.layer?.borderColor = NSColor.systemBlue.cgColor
            }else {
                view.layer?.borderColor = NSColor.white.cgColor
            }
        }
    }
    
}

// MARK: - override
extension ClipboardItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // 确保视图支持图层
        view.wantsLayer = true
        
        // 设置默认背景颜色
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        // 设置视图边框样式（可选）
        view.layer?.cornerRadius = 8
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.white.cgColor
        
        
        // 确保视图支持图层
        textCountBGView.wantsLayer = true
        // 设置默认背景颜色
        textCountBGView.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.3).cgColor
        
    }
}
