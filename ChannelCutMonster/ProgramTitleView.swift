//
//  ProgramTitleView.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/07.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit


class ProgramTitleView: UIView {
    
    @IBOutlet weak var thumbView: UIImageView?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    // コードから初期化はここから
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    
    private func comminInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ProgramTitleView", bundle: bundle)
        let view:UIView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        self.addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
    }
}
