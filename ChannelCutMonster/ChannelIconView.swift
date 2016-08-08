//
//  ChannelIconView.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/07.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit

class ChannelIconView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: IconViewDelegate! = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        loadXib()
    }
    
    
    override func awakeFromNib() {
        let view = NSBundle.mainBundle().loadNibNamed("ChannelIconView", owner: self, options: nil).first as? ChannelIconView
        
        addSubview(view!)
        
        //        contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
//        addSubview(contentView)
    }
    
//    private func loadXib() {
//        NSBundle.mainBundle().loadNibNamed("ChannelIcon", owner: self, options: nil)
//        contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
//        addSubview(contentView)
//    }
}



protocol IconViewDelegate: class {
    func buttonDidTap(sender: ChannelIconView)
}
