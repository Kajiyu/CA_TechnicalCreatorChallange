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
    var icons: [UIView] = []
    
    var currentVideoName : String = ""
    
    
    var favoriteChannels : [ChannelInfo] = [ChannelInfo]()
    var nowSelectedChannel : ChannelInfo? = nil
    
    
    let motionManager = CMMotionManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentVideoName = "news1"
        setVideo(currentVideoName);
        play(currentVideoTime)
        createShortCutIcon()
        manageTagValue()
        
        
        /////加速度処理//////
        motionManager.accelerometerUpdateInterval = 0.1
        let accelerometerHandler:CMAccelerometerHandler = {
            (data: CMAccelerometerData?, error: NSError?) -> Void in
            
            let accelx = data!.acceleration.x
            let accelz = data!.acceleration.y
            
            let ikiti = sqrt(accelx*accelx + accelz*accelz)
//            print("x: \(ikiti)")
            
            if ikiti > 5.0 {
                self.performSegueWithIdentifier("fromTVtoList",sender: nil)
            }
            // 取得した値をコンソールに表示
            //            print("x: \(data!.acceleration.x)")
        }
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: accelerometerHandler)
        ///////////////////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
////        if let touch = touches.first as UITouch? {
////            let tag = touch.view!.tag
////            if tag == 1 {
////                startPoint = touch.locationInView(self.view)
////                imageBeHereNowPoint = touch.view!.frame.origin
////            }
////        }
////        let touch = touches.first as! UITouch
////            let tag = touch.view!.tag
////            if tag == 1 {
////                startPoint = touch.locationInView(self.view)
////                imageBeHereNowPoint = touch.view!.frame.origin
////            }
//         print(touches.first!.view?.tag)
//    }
    
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        // タッチイベントを取得
//        let touchEvent = touches.first!
//        if touchEvent.view!.tag == 1 {
//            // ドラッグ前の座標, Swift 1.2 から
//            let preDx = touchEvent.previousLocationInView(self.view).x
//            let preDy = touchEvent.previousLocationInView(self.view).y
//            
//            // ドラッグ後の座標
//            let newDx = touchEvent.locationInView(self.view).x
//            let newDy = touchEvent.locationInView(self.view).y
//            
//            // ドラッグしたx座標の移動距離
//            let dx = newDx - preDx
//            print("x:\(dx)")
//            
//            // ドラッグしたy座標の移動距離
//            let dy = newDy - preDy
//            print("y:\(dy)")
//            
//            // 画像のフレーム
//            var viewFrame: CGRect = touchEvent.view!.frame
//            
//            // 移動分を反映させる
//            viewFrame.origin.x += dx
//            viewFrame.origin.y += dy
//            
//            touchEvent.view!.frame = viewFrame
//            
////            self.view.addSubview(touchEvent.view!)
//        }
////        for touch: UITouch in touches {
////            let tag = touch.view!.tag
////                if tag == 1 {
////                    let location: CGPoint = touch.locationInView(self.view)
////                    let deltaX: CGFloat = CGFloat(location.x - startPoint!.x)
////                    let deltaY: CGFloat = CGFloat(location.y - startPoint!.y)
////                    touch.view!.frame.origin.x = imageBeHereNowPoint!.x + deltaX
////                    touch.view!.frame.origin.y = imageBeHereNowPoint!.y + deltaY
////                }
////        }
//    }
    
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//         print("End")
//    }
    
    
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
//            listViewController.currentVideoTime = 
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
        for icon in icons {
            icon.tag = 1
        }
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
            let shortCut = UIView(frame:CGRectMake(0, 0, 40, 40))
            shortCut.layer.cornerRadius = 2.5
            let image = UIImageView(frame:CGRectMake(0,0,shortCut.bounds.width, shortCut.bounds.height))
            let img = UIImage(named: "fox.png")
//            image.image = img
//            image.layer.cornerRadius = 2.5
//            shortCut.addSubview(image)
            let button = UIButton(frame:CGRectMake(0,0,shortCut.bounds.width,shortCut.bounds.height))
            button.backgroundColor = UIColor.redColor()
            shortCut.addSubview(button)
            shortCut.layer.position = CGPointMake(self.view.frame.width*((CGFloat(index)%3)+1)/4, self.view.frame.height*3/4 + 50*(CGFloat(index)/3))
            shortCut.tag = index
            icons.append(shortCut)
            index += 1
//            self.view.addSubview(shortCut)

        }
        if icons.last != nil {
            for icon in icons {
                ///タップ処理
                let dragGesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "dragged:")
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
    
}
