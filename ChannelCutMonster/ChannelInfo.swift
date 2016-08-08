//
//  ChannelInfo.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit


class ChannelInfo {
    var channelId : Int?
    var channelName : String?
    var channelThumb : String?
    var channelDetail : String?
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
    
    
    ////////////////
    var id : Int {
        get{
            return self.channelId!
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
