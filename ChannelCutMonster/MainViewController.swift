//
//  MainViewController.swift
//  ChannelCutMonster
//
//  Created by KajiharaYuma on 2016/08/05.
//  Copyright © 2016年 KajiharaYuma. All rights reserved.
//

import CoreMotion
import UIKit


class MainViewController : UITabBarController {
    let motionManager = CMMotionManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var viewControllers: [UIViewController] = []
        
        let firstViewController = TVViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.MostRecent, tag: 1)
        viewControllers.append(firstViewController)
        
        let secondViewController = ListViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.MostViewed, tag: 2)
        viewControllers.append(secondViewController)
        
        let thirdViewController = TimeLineViewController()
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 3)
        viewControllers.append(thirdViewController)
        
        self.setViewControllers(viewControllers, animated: false)
        
        
        // なぜか0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0
        
        
        
        /////加速度処理//////
        motionManager.accelerometerUpdateInterval = 0.1
        let accelerometerHandler:CMAccelerometerHandler = {
            (data: CMAccelerometerData?, error: NSError?) -> Void in
            
            let accelx = data!.acceleration.x
            let accelz = data!.acceleration.y
            
            let ikiti = sqrt(accelx*accelx + accelz*accelz)
            print("x: \(ikiti)")
            
            if ikiti > 5.0 {
                
            }
            // 取得した値をコンソールに表示
//            print("x: \(data!.acceleration.x)")
        }
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: accelerometerHandler)
        ///////////////////
        
        
        
    }
}
