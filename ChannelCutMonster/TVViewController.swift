//
//  TVViewController.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class TVViewController: UIViewController {
    
    
    @IBOutlet weak var channelThumb: UIImageView!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var programTitleLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var channelDetailView: UITextView!
    
    @IBOutlet weak var TVView: AVPlayerView?
    
    
    @IBOutlet weak var addChannelButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    var playerItem : AVPlayerItem? = nil
    var videoPlayer : AVPlayer? = nil
    var videoTimeObserver: AnyObject? = nil
    
    
    //タイマー
    var timer = NSTimer()
    var countNum = 0
    var currentVideoTime:Float64 = 0
    
    
    var result: [[String]] = []//Programsの配列
    
    
    var currentVideoName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentVideoName = "news1"
        setVideo(currentVideoName);
        play(currentVideoTime)
        manageTagValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        for touch: UITouch in touches {
//            let tag = touch.view!.tag
        }
    }
    
    
    //画面遷移の際の値渡し
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goAddViewSegue" {
            pause()
            let addChannelViewController : AddChannelViewController = segue.destinationViewController as! AddChannelViewController
            addChannelViewController.currentVideoTime = self.currentVideoTime
            addChannelViewController.currentVideoName = self.currentVideoName
        }
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
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(TVViewController.update), userInfo: nil, repeats: true)
    }
    
    func pause()  {
        self.videoPlayer!.pause()
        timer.invalidate()
    }
    
    func reset() {
        countNum  = 0
    }
    
    
    //viewのtagはここで管理
    func manageTagValue() -> Void {
        addChannelButton.tag = 1
        settingButton.tag = 2
    }
    
    @IBAction func setting(sender: UIButton) {
    }
    
    
    //AddChannelViewから戻ってきた時の処理
    @IBAction func backFromAddChannelView(segue:UIStoryboardSegue){
        let addChannelViewController : AddChannelViewController = segue.sourceViewController as! AddChannelViewController
        addChannelViewController.pause()
        self.currentVideoTime = addChannelViewController.currentVideoTime
        self.currentVideoName = addChannelViewController.currentVideoName
        play(currentVideoTime)
    }
    
    
    func update() {
        countNum += 1
        currentVideoTime = CMTimeGetSeconds(videoPlayer!.currentTime())
//        print(currentVideoTime)
    }
    
    
//    @IBAction func addChannel(sender: UIButton) {
//        pause()
//        print(self.videoPlayer!.currentTime())
//        let next: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("AddChannelViewController") as UIViewController
////        let addView = AddChannelViewController()
//        next.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        self.presentViewController(next, animated: true, completion: nil)
//    }
    
    
    
}
