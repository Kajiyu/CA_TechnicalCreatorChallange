//
//  ListViewController.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreMotion

class ListViewController : UIViewController {
    
    
    @IBOutlet weak var TVView: AVPlayerView?
    
    
    var playerItem : AVPlayerItem? = nil
    var videoPlayer : AVPlayer? = nil
    var videoTimeObserver: AnyObject? = nil
    
    
    
    //タイマー
    var timer = NSTimer()
    var countNum = 0
    var currentVideoTime:Float64 = 0
    
    var currentVideoName : String = ""
    
    let motionManager = CMMotionManager()
    
    var channels : [ChannelInfo] = [ChannelInfo]()
    var selectedChannel : ChannelInfo? = nil
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        if(currentVideoName == ""){
        } else {
            setVideo(currentVideoName);
        }
        play(currentVideoTime)
    }
    
    
    
    func setVideo(f_name : String) -> Void {
        let path = NSBundle.mainBundle().pathForResource(f_name, ofType: "mp4")
        let fileURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(URL: fileURL, options: nil)
        self.playerItem = AVPlayerItem(asset: avAsset)
        self.videoPlayer = AVPlayer(playerItem: self.playerItem!)
        self.TVView!.setPlayer(self.videoPlayer!)
        self.TVView!.setVideoFillMode(AVLayerVideoGravityResizeAspect)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
    }
    
    
    func play(seekTime: Float64) {
        self.videoPlayer!.seekToTime(CMTimeMakeWithSeconds(currentVideoTime,Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        self.videoPlayer!.play()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(AddChannelViewController.update), userInfo: nil, repeats: true)
    }
    
    func pause()  {
        self.videoPlayer!.pause()
        timer.invalidate()
    }
    
    func reset() {
        countNum  = 0
    }
    
    func update() {
        countNum += 1
        currentVideoTime = CMTimeGetSeconds(videoPlayer!.currentTime())
        //        print(currentVideoTime)
    }
}