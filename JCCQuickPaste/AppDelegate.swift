//
//  AppDelegate.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    var mainPanelController: MainPanelController!

    /// 剪切板
    let clipboard = Clipboard()
    
    /// 状态栏
    var statusItem: NSStatusItem!
    
    var statusMenu: NSMenu!
    
    /// 全局快捷键
    var globalHotKeyID = EventHotKeyID()
    var globalHotKeyRef: EventHotKeyRef?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        addStatusBar()
        
        mainPanelController = MainPanelController()
         
        addListener()
        
        requestAccessibilityPermission()
        
        showPanel()
        
        
    }


    
    func applicationWillTerminate(_ aNotification: Notification) {
        mainPanelController = nil
        // 取消注册快捷键
        if let hotKeyRef = globalHotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
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
        registerGlobalKeyDown()
    }
    
    func addClipboardListener() {
        clipboard.startListening()
        clipboard.onNewCopy {
            ClipboardDataStorage.shared.add($0)
            NotificationCenter.default.post(name: .clipboardContentDidChange, object: nil)
        }
    }

    func registerGlobalKeyDown() {
        // 设置全局快捷键：Shift + Cmd + 0
        
        globalHotKeyID.signature = OSType("htk1".utf8.reduce(0) { ($0 << 8) | UInt32($1) })
        globalHotKeyID.id = UInt32(1)
        
        let modifiers: UInt32 = UInt32(cmdKey | shiftKey) // Cmd + Shift
        let keyCode: UInt32 = 29                 // 0 键的 keyCode
        
        // 注册快捷键
        let status = RegisterEventHotKey(keyCode, modifiers, globalHotKeyID, GetApplicationEventTarget(), 0, &globalHotKeyRef)
        if status != noErr {
            print("注册快捷键失败")
            return
        }
        
        // 安装事件处理器
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        InstallEventHandler(GetApplicationEventTarget(), hotKeyHandler, 1, &eventSpec, Unmanaged.passUnretained(self).toOpaque(), nil)
        
        print("快捷键注册成功")
    }

    
}

// 回调函数：处理快捷键事件
private func hotKeyHandler(nextHandler: EventHandlerCallRef?, event: EventRef?, userData: UnsafeMutableRawPointer?) -> OSStatus {
    guard let event = event else { return noErr }

    let eventKind = GetEventKind(event)
    if eventKind == kEventHotKeyPressed {
        // 快捷键触发，执行操作
        DispatchQueue.main.async {
            let appDelegate = NSApplication.shared.delegate as? AppDelegate
            appDelegate?.showPanel()
        }
    }
    return noErr
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
//        statusMenu.addItem(NSMenuItem(title: "打开面板", action: #selector(openPanel), keyEquivalent: "o"))
//        statusMenu.addItem(NSMenuItem.separator())
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
    

    @objc
    func terminateApp() {
        NSApplication.shared.terminate(nil)
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
