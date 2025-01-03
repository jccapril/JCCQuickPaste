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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        mainPanelController = MainPanelController()
        
        mainPanelController?.showPanel()
        // 添加快捷键监听
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            print("aaa")
            self?.handleKeyDown(event)
        }
    }

    // 处理按键事件
    func handleKeyDown(_ event: NSEvent) {
        // 检查是否按下了 Command + O
        if event.modifierFlags.contains(.command),   // 检查 Command 键
           event.modifierFlags.contains(.option),    // 检查 Option 键
           event.charactersIgnoringModifiers == "p" { // 检查按键字符
            mainPanelController?.showPanel() // 显示面板
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        mainPanelController = nil
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

