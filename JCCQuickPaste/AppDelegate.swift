//
//  AppDelegate.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainPanelController: MainPanelController!

    let clipboard = Clipboard()
    
    var statusItem: NSStatusItem!
    
    var statusMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        addStatusBar()
        
        mainPanelController = MainPanelController()
         
        addListener()
        
        requestAccessibilityPermission()
        
        showPanel()
    }


    
    func applicationWillTerminate(_ aNotification: Notification) {
        mainPanelController = nil
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

// MARK: - Action
private extension AppDelegate {
    
    func showPanel() {
        mainPanelController.showPanel()
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
        // 设置全局快捷键监听
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.isTriggerKey(event) == true {
                self?.showPanel() // 显示面板
            }
        }
    }
    
    
    
}

// MARK: - Status
private extension AppDelegate {
    
    func addStatusBar() {
        // 创建一个状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "paperclip", accessibilityDescription: "Clipboard") // 可选图标
            button.target = self
            button.action = #selector(statusBarItemClicked) // 左键单击事件
            button.sendAction(on: [.leftMouseUp, .rightMouseUp]) // 同时监听左右键
        }
        
        // 创建菜单
        statusMenu = NSMenu()
        statusMenu.addItem(NSMenuItem(title: "打开面板", action: #selector(openPanel), keyEquivalent: "o"))
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "退出", action: #selector(terminateApp), keyEquivalent: "q"))
    }
    
    @objc func statusBarItemClicked() {
        // 判断鼠标事件类型
        let currentEvent = NSApp.currentEvent
        if currentEvent?.type == .rightMouseUp {
            // 右键单击显示菜单
            if let button = statusItem.button {
                statusMenu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
            }
        } else {
            // 左键单击逻辑
            showPanel()
        }
    }
    
    

    @objc func openPanel() {
        showPanel()
    }

    @objc func terminateApp() {
        NSApplication.shared.terminate(nil)
    }
    
    
}

// MARK: - 按键监控
private extension AppDelegate {
    
    // 判断是否是自定义快捷键 (Command + Option + O)
    func isTriggerKey(_ event: NSEvent) -> Bool {
        return event.modifierFlags.contains([.command, .option]) && event.charactersIgnoringModifiers == "z"
    }
    
}

// MARK: - Permission
private extension AppDelegate {
    
    
    func requestAccessibilityPermission() {
        let options: [String: AnyObject] = [
            kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true as AnyObject
        ]

        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        if !accessEnabled {
            print("未授权辅助功能权限，请提示用户手动开启。")
        }
    }
    
}
