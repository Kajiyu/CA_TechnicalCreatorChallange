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
import CoreMotion

class TVViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
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
    
    
    var startPoint: CGPoint?
    var imageBeHereNowPoint: CGPoint?
    
    
    //タイマー
    var timer = NSTimer()
    var countNum = 0
    var currentVideoTime:Float64 = 0
    
    
    //var result: [[String]] = []//Programsの配列
    var icons: [ChannelIconView] = []
    
    var currentVideoName : String = ""
    
    
    var favoriteChannels : [ChannelInfo] = [ChannelInfo]()
    var nowSelectedChannel : ChannelInfo? = nil
    var Channels = ChannelManager.sharedManager
    
    let motionManager = CMMotionManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if currentVideoName == "" {
            currentVideoName = "news1"
        } else {
        }
        setVideo(currentVideoName);
        play(currentVideoTime)
        createShortCutIcon()
        manageTagValue()
        
        
        ////傾き処理///
//        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            
            var attitude: CMAttitude = deviceManager!.attitude
            if attitude.roll*10 < -6 {
                self.performSegueWithIdentifier("fromTVtoList",sender: nil)
                self.motionManager.stopDeviceMotionUpdates()
            }
        })
        ///////////////////
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            
            var attitude: CMAttitude = deviceManager!.attitude
            if attitude.roll*10 < -6 {
                self.performSegueWithIdentifier("fromTVtoList",sender: nil)
                self.motionManager.stopDeviceMotionUpdates()
            }
        })
        play(currentVideoTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //画面遷移の際の値渡し
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goAddViewSegue" {
            pause()
            let addChannelViewController : AddChannelViewController = segue.destinationViewController as! AddChannelViewController
            addChannelViewController.currentVideoTime = self.currentVideoTime
            addChannelViewController.currentVideoName = self.currentVideoName
        }
        
        if segue.identifier == "fromTVtoList" {
            pause()
            let listViewController : ListViewController = segue.destinationViewController as! ListViewController
            listViewController.currentVideoName = self.currentVideoName
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
        var index : Int = 0
//        for icon in icons {
//            icon.tag = 1
//        }
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
    
    var index : Int = 0
    func createShortCutIcon() -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let favChannelNum = defaults.objectForKey("favnum") as? Int {
            for i in 1...favChannelNum {
                let data: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey(String(i))
                var channel : ChannelInfo
                if data != nil {
                    channel = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! ChannelInfo
                    favoriteChannels.append(channel)
                }
            }
        } else {
        }
        for channel in favoriteChannels {
            print(channel.channelName)
//            let x:CGFloat = self.view.bounds.origin.x
//            let y:CGFloat = self.view.bounds.origin.y
//            let width:CGFloat = 30
////            let height:CGFloat = 30
//            let frame:CGRect = CGRect(x: x, y: y, width: width, height: height)
            let shortCut = ChannelIconView(frame:CGRectMake(0, 0, 40, 40))
            shortCut.layer.cornerRadius = 2.5
            let image = UIImageView(frame:CGRectMake(0,0,shortCut.bounds.width, shortCut.bounds.height))
            let img = UIImage(named: "fox.png")
            image.image = img
            image.layer.cornerRadius = 2.5
            shortCut.addSubview(image)
            shortCut.layer.position = CGPointMake(self.view.frame.width*((CGFloat(index)%3)+1)/4, self.view.frame.height*3/4 + 50*(CGFloat(index)/3))
            shortCut.tag = index
            shortCut.movieName = channel.channelMovie
            icons.append(shortCut)
            index += 1
//            self.view.addSubview(shortCut)

        }
        if icons.last != nil {
            for icon in icons {
                ///タップ処理
                let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TVViewController.tapped(_:)))
                tapGesture.delegate = self
                icon.addGestureRecognizer(tapGesture)
                ///
                ///パン処理
                let dragGesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TVViewController.dragged(_:)))
                dragGesture.delegate = self
                icon.addGestureRecognizer(dragGesture)
                ///
                self.view.addSubview(icon)
            }
        }
    }
    
    
    func dragged(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func tapped(recognizer: UITapGestureRecognizer) {
        pause()
        self.currentVideoName = Channels.channels[(recognizer.view?.tag)!].channelMovie!
        nowSelectedChannel = Channels.channels[(recognizer.view?.tag)!]
        setVideo(currentVideoName)
        
        currentVideoTime = 0
        play(currentVideoTime)
    }
    
}
