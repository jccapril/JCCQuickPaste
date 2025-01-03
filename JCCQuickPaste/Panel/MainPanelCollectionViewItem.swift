//
//  MainPanelCollectionViewItem.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

class MainPanelCollectionViewItem: NSCollectionViewItem {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.textField = NSTextField(labelWithString: "")
//        self.textField?.alignment = .center
//        self.textField?.frame = self.view.bounds
//        self.textField?.font = NSFont.systemFont(ofSize: 14)
//        self.textField?.textColor = NSColor.black
//        self.view.addSubview(self.textField!)
        
        // 确保视图支持图层
        view.wantsLayer = true
        // 设置默认背景颜色
        view.layer?.backgroundColor = NSColor.red.cgColor
        
        // 设置视图边框样式（可选）
        view.layer?.cornerRadius = 8
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.lightGray.cgColor
           
    }
}
