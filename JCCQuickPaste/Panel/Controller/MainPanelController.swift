//
//  MainPanelController.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

class MainPanelController: NSWindowController {
    
    /// 屏幕尺寸
    static let screenFrame: NSRect = {
        guard let screenFrame = NSScreen.main?.frame else {
            fatalError("无法获取屏幕尺寸")
        }
        return screenFrame
    }()
    
    /// 定义面板尺寸
    static let panelRect: NSRect = {
        // 定义面板尺寸：宽度为屏幕宽度，高度自定义，y 坐标设为屏幕底部
        let panelRect = NSRect(x: screenFrame.origin.x,
                               y: screenFrame.origin.y,
                               width: screenFrame.width,
                               height: AppCenter.panelHeight)
        return panelRect
    }()
    
    private var collectionView: NSCollectionView!
    
    init() {
        // 创建 NSPanel
        let panel = MainPanel(contentRect: Self.panelRect,
                              styleMask: [.borderless, .nonactivatingPanel],
                            backing: .buffered,
                            defer: false)
        
        // 初始化 NSWindowController
        super.init(window: panel)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showPanel() {
        
        if let panel = window {
            print("Panel is initialized")
            if panel.isVisible {
                print("Panel is already visible")
                DispatchQueue.main.async {
                    self.window?.orderOut(nil)
                }
            } else {
                print("Panel is not visible, attempting to show it")
                DispatchQueue.main.async {
                    NSApp.activate()
                    panel.makeKeyAndOrderFront(nil)
                }
            }
        } else {
            print("Panel is nil")
        }
    }
}


