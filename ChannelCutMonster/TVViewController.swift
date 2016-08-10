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
import SCLAlertView

class TVViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var channelThumb: UIImageView!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var right: UIImageView!
    
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
            nowSelectedChannel = Channels.channels[0]
            print(nowSelectedChannel!.channelMovie!)
            currentVideoName = nowSelectedChannel!.channelMovie!
        } else {
            print(nowSelectedChannel!.channelMovie!)
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
            if(attitude.roll < 0){
                self.right.alpha = (  CGFloat((-1)*attitude.roll)*10)/6
            } else {
                self.right.alpha = 0
            }
            if attitude.roll*10 < -6 {
                self.performSegueWithIdentifier("fromTVtoList",sender: nil)
                self.motionManager.stopDeviceMotionUpdates()
            }
        })
        ///////////////////
        programTitleLabel.text = nowSelectedChannel!.programName
        channelThumb.image = UIImage(named: nowSelectedChannel!.channelThumb!)
        channelDetailView.text = nowSelectedChannel!.programDetail
        channelDetailView.editable = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            
            var attitude: CMAttitude = deviceManager!.attitude
            if(attitude.roll < 0){
                self.right.alpha = (  CGFloat((-1)*attitude.roll)*10)/6
            } else {
                self.right.alpha = 0
            }
            if attitude.roll*10 < -6 {
                self.performSegueWithIdentifier("fromTVtoList",sender: nil)
                self.motionManager.stopDeviceMotionUpdates()
            }
        })
        programTitleLabel.text = nowSelectedChannel!.programName
        channelThumb.image = UIImage(named: nowSelectedChannel!.channelThumb!)
        channelDetailView.text = nowSelectedChannel!.programDetail
        channelDetailView.editable = false
//        play(currentVideoTime)
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
            addChannelViewController.favoriteChannels = self.favoriteChannels
        }
        
        if segue.identifier == "fromTVtoList" {
//            pause()
            let listViewController : ListViewController = segue.destinationViewController as! ListViewController
            listViewController.currentVideoName = self.currentVideoName
            listViewController.nowSelectedChannel = self.nowSelectedChannel
            listViewController.favoriteChannels = self.favoriteChannels
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
//        self.currentVideoTime = 0
        self.currentVideoName = addChannelViewController.currentVideoName
        self.setVideo(currentVideoName)
        self.play(currentVideoTime)
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
                    print(channel.channelName)
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
            let img = UIImage(named: channel.channelThumb!)
            image.image = img
            image.layer.cornerRadius = 2.5
            shortCut.addSubview(image)
            shortCut.layer.position = CGPointMake(self.view.frame.width*((CGFloat(index)%5)+1)/6, self.view.frame.height*3/4 + 70)
            shortCut.tag = index
            print(shortCut.tag)
            print(channel.channelMovie)
            shortCut.movieName = channel.channelMovie
            shortCut.channelInfo = channel
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
                ///ロングタップ処理
                let longGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TVViewController.longPressed(_:)))
                longGesture.delegate = self
                icon.addGestureRecognizer(longGesture)
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
        print(recognizer.view!.tag)
        let tmp_view : ChannelIconView = recognizer.view as! ChannelIconView
        self.nowSelectedChannel! = tmp_view.channelInfo!
        print(tmp_view.channelInfo?.channelName)
        self.currentVideoName = tmp_view.movieName!
        setVideo(currentVideoName)
        programTitleLabel.text = nowSelectedChannel!.programName
        channelDetailView.text = nowSelectedChannel!.programDetail
        channelThumb.image = UIImage(named: nowSelectedChannel!.channelThumb!)
        currentVideoTime = 0
        play(currentVideoTime)
    }
    
    func longPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            print(self.favoriteChannels.count)
            let alertView = SCLAlertView()
            alertView.addButton("OK") {
                let tmp_view : ChannelIconView = recognizer.view as! ChannelIconView
                //            let viewtag : Int = recognizer.view!.tag
                let c_name : String = tmp_view.channelInfo!.channelName!
                if self.nowSelectedChannel!.channelName == tmp_view.channelInfo!.channelName {
//                    self.pause()
//                    tmp_view.removeFromSuperview()
//                    var _index : Int = 0
//                    for channel in self.favoriteChannels {
//                        if channel.channelName == c_name {
//                            self.favoriteChannels.removeAtIndex(_index)
//                            break
//                        }
//                        _index += 1
//                    }
//                    print(self.favoriteChannels.count)
//                    self.nowSelectedChannel = self.favoriteChannels[1]
//                    self.currentVideoName = self.nowSelectedChannel!.channelName!
//                    self.currentVideoTime = 0
//                    self.play(self.currentVideoTime)
                    //苦肉の索
                    SCLAlertView().showError("Error", subTitle: "別のチャンネルに切換えてから削除してください><")
                } else {
                    tmp_view.removeFromSuperview()
                    var _index : Int = 0
                    for channel in self.favoriteChannels {
                        if channel.channelName == c_name {
                            self.favoriteChannels.removeAtIndex(_index)
                            break
                        }
                        _index += 1
                    }
                }
            }
            alertView.showTitle(
                "Warning", // タイトル
                subTitle: "チャンネルを削除しますか？", // サブタイトル
                duration: 400, // 2.0秒ごに、自動的に閉じる（OKでも閉じることはできる）
                completeText: "Cancel", // クローズボタンのタイトル
                style: .Warning, // スタイル（Success)指定
                colorStyle: 0xFFFF00, // ボタン、シンボルの色
                colorTextButton: 0x000000 // ボタンの文字列の色0x000088
            )
        default:
            return
        }
        
        
    }
    
    
    @IBAction func goListButton(sender: AnyObject) {
        self.performSegueWithIdentifier("fromTVtoList",sender: nil)
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    
    
}
