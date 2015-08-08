//
//  AppDelegate.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/01/10.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //1行追加
    var myNavigationController: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().idleTimerDisabled = true //スリープしないように
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        var bgFlag:Bool = myUserDafault.boolForKey("bgm")
        
        let musicNameStr:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
        
        if(bgFlag==true){
            NotificationUtil.pushDelete()
            let lm = LangManager()
            for(var i=0;i<60;i++){
                // Notificationの生成する.
                let myNotification: UILocalNotification = UILocalNotification()
                // メッセージを代入する.
                myNotification.alertBody = lm.getString(13)
                // 再生サウンドを設定する.
                myNotification.soundName = musicNameStr + ".caf"
                // Timezoneを設定する.
                myNotification.timeZone = NSTimeZone.defaultTimeZone()
                // 10秒後に設定する.
                myNotification.fireDate = NSDate(timeIntervalSinceNow: 1+(Double(i)*30))
                // Notificationを表示する.
                UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
            }
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //println("\nアクティブになりました")
        //musicCome()
    }
    func musicCome(){
        let main = EditViewController()
        main.bgFlag = main.myUserDafault.boolForKey("bgm")
        //main.alertComeCheck()
        if(main.bgFlag==true){
            //println("bgm trueだから流しとくかな")
            //            AVAudioPlayerUtil.play();//再生
            //            NotificationUtil.pushDelete()
            //バイブも鳴らす
            //            main.vibTimer = NSTimer.scheduledTimerWithTimeInterval(main.vibInterval, target: self, selector: "vibUpdate", userInfo: nil, repeats: true)
            //一歩目限定イベント
            //            let mc = musicController() //音楽コントローラ
            
            if(main.myUserDafault.boolForKey("HAJIMEIPPO_STILL") == true){
                AVAudioPlayerUtil.playMusicVolumeSetting(1.0)
            }
            else{
                AVAudioPlayerUtil.playMusicVolumeSetting(0.05)
            }
            main.myUserDafault.setInteger(5, forKey: "TUTORIALLIFE") //5は通常稼働
            main.myUserDafault.synchronize()
        }
        else{
            main.noMusicInit()
        }
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        if(myUserDafault.boolForKey("bgm")==true){
            NotificationUtil.pushDelete()
            let lm = LangManager()
            let musicNameStr:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
            for(var i=0;i<60;i++){
                let myNotification: UILocalNotification = UILocalNotification()
                myNotification.alertBody = lm.getString(13)
                myNotification.soundName = musicNameStr + ".caf"
                myNotification.timeZone = NSTimeZone.defaultTimeZone()
                // 10秒後に設定する.
                myNotification.fireDate = NSDate(timeIntervalSinceNow: 1+(Double(i)*30))
                // Notificationを表示する.
                UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
            }
        }
    }
}