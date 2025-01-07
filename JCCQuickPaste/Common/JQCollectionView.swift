//
//  JQCollectionView.swift
//  JCCQuickPaste
//
//  Created by Jiang Chencheng on 2025/1/7.
//

import Cocoa

protocol JQCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectedItemAt indexPath: IndexPath)
}

class JQCollectionView: NSCollectionView {
    
    var jq_delegate: JQCollectionViewDelegate?
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let point = self.convert(event.locationInWindow, from: nil)
        if let indexPath = self.indexPathForItem(at: point),
           let delegate = self.jq_delegate {
            delegate.collectionView(self, didSelectedItemAt: indexPath)
        }
        
    }
}
