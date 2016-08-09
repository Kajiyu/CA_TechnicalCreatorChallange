//
//  ChannelManager.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/09.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit

class ChannelManager {
    
    var channels : [ChannelInfo] = [ChannelInfo]()
    
    static let sharedManager = ChannelManager()
    private init() {
        initPrograms()
    }
    
    func initPrograms() {
        let filePath = NSBundle.mainBundle().pathForResource("channels.plist", ofType: nil)
        let infoList = NSMutableDictionary(contentsOfFile: filePath!)
        
        var isFinished : Bool = false
        var count : Int = 0
        while isFinished == false {
            if let value : AnyObject = infoList?.objectForKey(String(count)){
                //                let id : Int = value.objectForKey("id") as! Int
                let name : String = value.objectForKey("name") as! String
                let imgName : String = value.objectForKey("thumb") as! String
                let detail : String = value.objectForKey("detail") as! String
                let movie : String = value.objectForKey("movie") as! String
                let tmp_channel = ChannelInfo(_name: name, _thumb: imgName, _detail: detail)
                tmp_channel.channelMovie = movie
                channels.append(tmp_channel)
                count += 1
            } else {
                isFinished = true
            }
        }
        
    }
}
