//
//  ChannelInfo.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit


class ChannelInfo : NSObject,NSCoding {
    var channelId : Int = 0
    var channelName : String?
    var channelThumb : String?
    var channelDetail : String?
    var channelMovie : String?
    var programName : String?
    var programDetail : String?
    
    //コンストラクタ
    init(_name : String, _thumb: String, _detail:String) {
        self.channelName = _name
        self.channelThumb = _thumb
        self.channelDetail = _detail
    }
    
    
    //デストラクタ
    deinit {
    }
    
    //シリアライズ
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(channelId, forKey: "id")
        aCoder.encodeObject(channelName, forKey: "name")
        aCoder.encodeObject(channelThumb, forKey:  "thumb")
        aCoder.encodeObject(channelDetail, forKey: "detail")
        aCoder.encodeObject(channelMovie, forKey: "movie")
        aCoder.encodeObject(programName, forKey: "programName")
        aCoder.encodeObject(programDetail, forKey: "programDetail")
    }
    
    //デシリアライズ
    required init(coder: NSCoder) {
        self.channelId = coder.decodeObjectForKey("id") as! Int
        self.channelName = coder.decodeObjectForKey("name") as! String
        self.channelThumb = coder.decodeObjectForKey("thumb") as! String
        self.channelDetail = coder.decodeObjectForKey("detail") as! String
        self.channelMovie = coder.decodeObjectForKey("movie") as! String
        self.programName = coder.decodeObjectForKey("programName") as! String
        self.programDetail = coder.decodeObjectForKey("programDetail") as! String
    }
    
    ////////////////
    var id : Int {
        get{
            return self.channelId
        }
        set(p) {
            self.channelId = p
        }
    }
    
    var name : String {
        get {
            return channelName!
        }
        set(p) {
            self.channelName = p
        }
    }
    
    var thumb : String {
        get{
            return channelThumb!
        }
        set(p) {
            self.channelThumb = p
        }
    }
    
    var detail : String {
        get{
            return channelDetail!
        }
        set(p){
            self.channelDetail = p
        }
    }
    ////////////////

}
