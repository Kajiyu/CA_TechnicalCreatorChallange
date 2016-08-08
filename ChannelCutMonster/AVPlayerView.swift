//
//  AVPlayerView.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import AVFoundation
import UIKit


class AVPlayerView : UIView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class func layerClass() -> AnyClass{
        return AVPlayerLayer.self
    }
    
    func player() -> AVPlayer {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        return layer.player!
    }
    
    
    func setPlayer(player: AVPlayer) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.player = player
    }
    
    
    func setVideoFillMode(fillMode: NSString) {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        layer.videoGravity = fillMode as String
    }
    
    func videoFillMode() -> NSString {
        let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
        return layer.videoGravity
    }
}