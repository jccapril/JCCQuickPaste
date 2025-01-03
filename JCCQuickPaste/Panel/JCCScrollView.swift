//
//  JCCScrollView.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

class JCCScrollView: NSScrollView {
    override var hasHorizontalScroller: Bool {
        get {
            return false
        }
        set {
            super.hasHorizontalScroller = newValue
        }
    }

    override var horizontalScroller: NSScroller? {
        get {
            return nil
        }
        set {
            super.horizontalScroller = newValue
        }
    }
    //comment it or use super for scrroling
    override func scrollWheel(with event: NSEvent) {}
}
