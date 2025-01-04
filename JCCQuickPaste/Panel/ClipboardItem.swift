//
//  ClipboardItem.swift
//  JCCQuickPaste
//
//  Created by 蒋晨成 on 2025/1/4.
//

import Cocoa

class ClipboardItem: NSCollectionViewItem {
    @IBOutlet weak var textLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // 确保视图支持图层
        view.wantsLayer = true
        // 设置默认背景颜色
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        // 设置视图边框样式（可选）
        view.layer?.cornerRadius = 8
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.lightGray.cgColor
    }
    
}
