//
//  ProgramInfo.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit


class ProgramInfo {
    
    var programName : String?
    var programDetail : String?
    var programThumb : UIImage?
    var programMovie : String?
    var programStartTime : String?
    var programEndTime : String?
    
    //コンストラクタ
    init(_name : String, _detail : String, _Thumb : UIImage, _movie : String){
        self.programName = _name
        self.programDetail = _detail
        self.programThumb = _Thumb
        self.programMovie = _movie
    }
    
    ///デストラクタ
    deinit{
    }
    
    
    
    func setTime(_startTime : String, _endTime : String) -> Void {
        self.programStartTime = _startTime
        self.programEndTime = _endTime
    }
}
