//
//  AddChannelTableCell.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/08.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit


class AddChannelTableCell : UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(channel : ChannelInfo) {
        self.name.text = channel.channelName
        let url :String = channel.channelThumb!
        let imageData :NSData
        do {
            if let imagePath : String = NSBundle.mainBundle().pathForResource(url, ofType: "png") {
                let fileHandle : NSFileHandle = NSFileHandle(forReadingAtPath: imagePath)!
                imageData = fileHandle.readDataToEndOfFile()
                let img = UIImage(data:imageData)
                self.iconImage.image = img
            } else {
                print("erooorddayo!!")
            }
        } catch {
            print("Error: can't create image.")
        }
    }
}
