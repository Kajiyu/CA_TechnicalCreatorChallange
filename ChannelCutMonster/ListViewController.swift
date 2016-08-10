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

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var right: UIImageView!
    @IBOutlet weak var channelsTable: UITableView!
    @IBOutlet weak var timeTable: UITableView!
    
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelThumb: UIImageView!
    
    
    var playerItem : AVPlayerItem? = nil
    var videoPlayer : AVPlayer? = nil
    var videoTimeObserver: AnyObject? = nil
    
    
    var currentVideoName : String = ""
    
    let motionManager = CMMotionManager()
    
    var nowSelectedChannel : ChannelInfo? = nil
    var listSelectedChannel : ChannelInfo? = nil
    var Channels = ChannelManager.sharedManager
    var favoriteChannels : [ChannelInfo] = [ChannelInfo]()
    
    
    var icons: [ChannelIconView] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createShortCutIcon()
        
        /////傾き処理//////
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            self.listSelectedChannel = self.nowSelectedChannel
            self.channelName.text = self.listSelectedChannel!.channelName
            self.channelThumb.image = UIImage(named: self.listSelectedChannel!.channelThumb!)
            let attitude: CMAttitude = deviceManager!.attitude
            
            if(attitude.roll > 0){
                self.right.alpha = (  CGFloat(attitude.roll)*10)/6
            } else {
                self.right.alpha = 0
            }
            
            if attitude.roll*10 > 6 {
//                self.performSegueWithIdentifier("fromListToTV",sender: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.motionManager.stopDeviceMotionUpdates()
            }
        })
        ///////////////////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromListToTV" {
            let tvViewController : TVViewController = segue.destinationViewController as! TVViewController
            tvViewController.currentVideoName = self.currentVideoName
            tvViewController.nowSelectedChannel = self.nowSelectedChannel
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setVideo(f_name : String) -> Void {
        let path = NSBundle.mainBundle().pathForResource(f_name, ofType: "mp4")
        let fileURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(URL: fileURL, options: nil)
        self.playerItem = AVPlayerItem(asset: avAsset)
        self.videoPlayer = AVPlayer(playerItem: self.playerItem!)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        if tableView == timeTable {
            let cell: TimeLineTableViewCell = tableView.dequeueReusableCellWithIdentifier("timeLineTableViewCell", forIndexPath: indexPath) as! TimeLineTableViewCell
            let currentDateTime = NSDate()
            let userCalendar = NSCalendar.currentCalendar()
            let requestedComponents: NSCalendarUnit = [
                NSCalendarUnit.Year,
                NSCalendarUnit.Month,
                NSCalendarUnit.Day,
                NSCalendarUnit.Hour,
                NSCalendarUnit.Minute,
                NSCalendarUnit.Second
            ]
            let dateTimeComponents = userCalendar.components(requestedComponents, fromDate: currentDateTime)
            let hour : Int = dateTimeComponents.hour + indexPath.row
            cell.hour.text = String(hour%24)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        } else {
            let cell : ChannelTableViewCell = tableView.dequeueReusableCellWithIdentifier("channelTableViewCell", forIndexPath: indexPath) as! ChannelTableViewCell
            let detail : String = nowSelectedChannel!.programDetail!
            let title : String = nowSelectedChannel!.programName!
            cell.setCell(title, _detail: detail)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == timeTable {
            timeTable.contentOffset = channelsTable.contentOffset
        }
        if scrollView == channelsTable {
            timeTable.contentOffset = channelsTable.contentOffset
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {}
    
    
    
    func createShortCutIcon() -> Void {
        var index : Int = 0
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
//        setVideo(currentVideoName)
//        programTitleLabel.text = nowSelectedChannel!.programName
//        channelDetailView.text = nowSelectedChannel!.programDetail
//        channelThumb.image = UIImage(named: nowSelectedChannel!.channelThumb!)
//        currentVideoTime = 0
//        play(currentVideoTime)
    }
    
    
    
    @IBAction func tapTVButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    
    @IBAction func tapChannelButton(sender: AnyObject) {
    }
    
}