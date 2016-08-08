//
//  AddChannelViewController.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/08.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import Foundation
import UIKit



class AddChannelViewController : UIViewController {
    @IBOutlet weak var TVView: AVPlayerView!
    
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backTVView(sender: AnyObject) {
    }
    
}
