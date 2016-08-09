//
//  ChannelTableViewCell.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/09.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_title: String, _detail : String){
        self.title.text = _title
        self.detail.text = _detail
        self.detail.editable = false
    }

}
