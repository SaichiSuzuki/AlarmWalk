//
//  AppDelegate.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/01/10.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SORPurchaseManagerDelegate {
    
//    var window: UIWindow?
//    //1行追加
//    var myNavigationController: UINavigationController?
    
    var window: UIWindow? = nil
    var navCon : UINavigationController? = nil
    var mainView : EditViewController? = nil
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().idleTimerDisabled = true //スリープしないように
        //メインコントローラー(ホーム画面となる)
        self.mainView = EditViewController();
        
        //ナビゲーションコントローラー
        self.navCon = UINavigationController(rootViewController: mainView!)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = navCon!
        self.window?.makeKeyAndVisible()

        //課金処理
        // デリゲート設定
        SORPurchaseManager.sharedManager().delegate = self
        // オブザーバー登録
        SKPaymentQueue.defaultQueue().addTransactionObserver(SORPurchaseManager.sharedManager())

        // ロック画面やコントロールセンターに再生ボタンなどのコントロールを表示する
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()


        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let myUserDafault:NSUserDefaults = NSUserDefaults()
        let bgFlag:Bool = myUserDafault.boolForKey("bgm")
        
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
//        println("\nバックグラウンドから復帰")
        mainView!.alertComeCheck()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
//        println("\nアクティブになりました")
        mainView!.alertComeCheck()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        let myUserDafault:NSUserDefaults = NSUserDefaults()
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
        
        // オブザーバー登録解除(課金関係)
        SKPaymentQueue.defaultQueue().removeTransactionObserver(SORPurchaseManager.sharedManager())
    }
    
    func purchaseManager(purchaseManager: SORPurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((complete: Bool) -> Void)!) {
        //課金終了(前回アプリ起動時課金処理が中断されていた場合呼ばれる)
        /*
        
        
        コンテンツ解放処理
        
        
        */
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(complete: true)
    }

}