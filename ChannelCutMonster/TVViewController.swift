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
    
    
    var result: [[String]] = []//Programsの配列
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setVideo("news1");
        play()
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
    
    
    func play() {
        self.videoPlayer!.play()
    }
    
    func pause()  {
        self.videoPlayer!.pause()
    }
    
    
    //viewのtagはここで管理
    func manageTagValue() -> Void {
        addChannelButton.tag = 1
        settingButton.tag = 2
    }
    
    @IBAction func setting(sender: UIButton) {
    }
    
    
    @IBAction func addChannel(sender: UIButton) {
        pause()
        print(self.videoPlayer!.currentTime())
        let addView = AddChannelViewController()
        addView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(addView, animated: true, completion: nil)
    }
    
    
    
}
