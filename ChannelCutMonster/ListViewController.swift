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

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var channelsTable: UITableView!
    @IBOutlet weak var timeTable: UITableView!
    
    
    var playerItem : AVPlayerItem? = nil
    var videoPlayer : AVPlayer? = nil
    var videoTimeObserver: AnyObject? = nil
    
    
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
        
        
        /////傾き処理//////
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            
            var attitude: CMAttitude = deviceManager!.attitude
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
            var hour : Int = dateTimeComponents.hour + indexPath.row
            cell.hour.text = String(hour%24)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        } else {
            let cell : ChannelTableViewCell = tableView.dequeueReusableCellWithIdentifier("channelTableViewCell", forIndexPath: indexPath) as! ChannelTableViewCell
            let detail : String = "Method 1 gave you the components, but it would be a lot of work to format those numbers for every style, language, and region."
            let title : String = "kakakkakkkakakak"
            cell.setCell(title, _detail: detail)
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {}
    
    
    @IBAction func tapTVButton(sender: AnyObject) {
    }
    
    
    @IBAction func tapChannelButton(sender: AnyObject) {
    }
    
}