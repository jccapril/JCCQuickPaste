//
//  AppDelegate.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainPanelController: MainPanelController?

    let clipboard = Clipboard()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        mainPanelController = MainPanelController()
        
        mainPanelController?.showPanel()

        addListener()
        
    }


    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        mainPanelController = nil
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

// MARK: - Listener
extension AppDelegate {
    
    func addListener() {
        addClipboardListener()
        addKeyboardListener()
    }
    
    func addClipboardListener() {
        clipboard.startListening()
        clipboard.onNewCopy {
            ClipboardDataStorage.shared.add($0)
            NotificationCenter.default.post(name: .clipboardContentDidChange, object: nil)
        }
    }
    
    func addKeyboardListener() {
        // 添加快捷键监听
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }
    }
    
    // 处理按键事件
    func handleKeyDown(_ event: NSEvent) {
        // 检查是否按下了 Command + Shift + v
        if event.modifierFlags.contains(.command),   // 检查 Command 键
           event.modifierFlags.contains(.shift),    // 检查 Shift 键
           event.charactersIgnoringModifiers == "v" { // 检查按键字符
            mainPanelController?.showPanel() // 显示面板
        }
    }
}
