//
//  MainPanel.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/3.
//

import Cocoa

class MainPanel: NSPanel {

    static let panelHeight: CGFloat = 300
    static let titleHeight: CGFloat = 20 // 标题高度
    
    private lazy var titleLabel: NSTextField = {
        let titleLabel = NSTextField(labelWithString: "Quick Paste")
        let titleWidth: CGFloat = 300 // 标题宽度
        
        titleLabel.frame = NSRect(x: (frame.width - titleWidth) / 2,
                                  y: Self.panelHeight - Self.titleHeight - 10, // 距离顶部 10 像素
                                  width: titleWidth,
                                  height: Self.titleHeight)
        titleLabel.font = NSFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.alignment = .center
        titleLabel.textColor = NSColor.black
        return titleLabel
    }()
    
    private lazy var scrollView: NSScrollView = {
        // 创建 NSCollectionView
        
        let collectionViewHeight = Self.panelHeight - Self.titleHeight - 40
        
        let collectionViewFrame = NSRect(x: 0, y: Self.titleHeight, width: frame.width, height: collectionViewHeight)
        let scrollView = NSScrollView(frame: collectionViewFrame)
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)

        // 初始化 CollectionView
        let itemWidth: CGFloat = collectionViewHeight - 40
        let padding: CGFloat = 20
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = NSEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.scrollDirection = .horizontal
        
        let collectionView = NSCollectionView(frame: collectionViewFrame)
        collectionView.collectionViewLayout = layout
        collectionView.register(MainPanelCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("MainPanelCollectionViewItem"))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColors = [NSColor.clear]
        scrollView.documentView = collectionView
        
        return scrollView
    }()
    
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        initializeUI()
    }
    
}

extension MainPanel {
    
    func initializeUI() {
        contentView?.addSubview(titleLabel)
        contentView?.addSubview(scrollView)
    }
    
}


extension MainPanel: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("MainPanelCollectionViewItem"), for: indexPath) as! MainPanelCollectionViewItem
//        item.textField?.stringValue = "Item \(indexPath.item)"
        return item
    }
}
