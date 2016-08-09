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
    var programs = [ProgramInfo]()
    
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
    }
    
    //デシリアライズ
    required init(coder: NSCoder) {
        self.channelId = coder.decodeObjectForKey("id") as! Int
        self.channelName = coder.decodeObjectForKey("name") as! String
        self.channelThumb = coder.decodeObjectForKey("thumb") as! String
        self.channelDetail = coder.decodeObjectForKey("detail") as! String
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
    
    
    func addProgram(_program : ProgramInfo)  {
        programs.append(_program)
    }
    
    func getProgram(index : Int) -> ProgramInfo {
        return programs[index]
    }
    
    
}
