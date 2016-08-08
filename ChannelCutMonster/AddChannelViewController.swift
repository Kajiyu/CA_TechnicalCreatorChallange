//
//  AddChannelViewController.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/08.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class AddChannelViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var TVView: AVPlayerView!
    @IBOutlet weak var tableView: UITableView!
    
    var playerItem : AVPlayerItem? = nil
    var videoPlayer : AVPlayer? = nil
    var videoTimeObserver: AnyObject? = nil
    
    
    var timer = NSTimer()
    var countNum = 0
    var currentVideoTime:Float64 = 0
    
    
    var currentVideoName : String = ""
    
    
    var channels : [ChannelInfo] = [ChannelInfo]()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable()
        initPrograms()
        // Do any additional setup after loading the view, typically from a nib.
        if(currentVideoName == ""){
        } else {
            setVideo(currentVideoName);
        }
        play(currentVideoTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    //table系のmethod
    func initTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    func initPrograms() {
//        let dammy1 = ChannelInfo(_name: "DisneyChannel", _thumb: NSURL(string: "http://oddjob.jp/news/img/TVKfes.jpg")!, _detail: "dddddd")
//        let dammy2 = ChannelInfo(_name: "ddadag", _thumb: NSURL(string: "http://logostock.jp/logostock/images/sakenomy.png.pagespeed.ce.QY_ReiI54J.png")!, _detail: "lsdcksdco")
//        let dammy3 = ChannelInfo(_name: "ddadag", _thumb: NSURL(string: "http://contents.oricon.co.jp/upimg/news/20150212/2048490_201502120742899001423684845c.jpg")!, _detail: "lsdcksdco")
//        channels.append(dammy1)
//        channels.append(dammy2)
//        channels.append(dammy3)
        let filePath = NSBundle.mainBundle().pathForResource("channels.plist", ofType: nil)
        let infoList = NSMutableDictionary(contentsOfFile: filePath!)
    
        var isFinished : Bool = false
        var count : Int = 0
        while isFinished == false {
            if let value : AnyObject = infoList?.objectForKey(String(count)){
                let id : Int = value.objectForKey("id") as! Int
                let name : String = value.objectForKey("name") as! String
                let imgName : String = value.objectForKey("thumb") as! String
                let detail : String = value.objectForKey("detail") as! String
                
                let tmp_channel = ChannelInfo(_name: name, _thumb: imgName, _detail: detail)
                channels.append(tmp_channel)
                count += 1
            } else {
                isFinished = true
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddChannelTableCell = tableView.dequeueReusableCellWithIdentifier("AddChannelTableCell", forIndexPath: indexPath) as! AddChannelTableCell
        cell.backgroundColor = UIColor.clearColor()
        cell.setCell(channels[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    
    @IBAction func backTVView(sender: AnyObject) {
    }
    
}
