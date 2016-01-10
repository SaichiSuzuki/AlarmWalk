//
//  NotificationManager.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/14.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
/**通知関係の処理をします*/
class NotificationManager :UIResponder{
    //通知回数
    var postTime = 80
    //設定時間と現在時刻の差
    var timeDifference = 0 //もらわないと
    //通知間隔時間
    var postInterval = 17
    
    init(diff:Int){
        self.timeDifference = diff
    }
    //プッシュ通知設定行う
    func postAlarm(){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(false, forKey: "PUSH")
        ud.synchronize()
        NotificationUtil.pushDelete()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "backThread", userInfo: nil, repeats: false)
    }
    
    func backThread(){
        let qualityOfServiceClass = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            // Backgroundで行いたい重い処理はここ
            self.pushSixteen()
            dispatch_async(dispatch_get_main_queue(), {
                // 処理が終わった後UIスレッドでやりたいことはここ
            })
        })
    }
    //通知仕込み処理
    func pushSixteen() {
        var cnt = 0
        //        println(timeDifference)
        let lm = LangManager()
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "PUSH")
        ud.synchronize()
        while(cnt < postTime) {
            if(ud.boolForKey("PUSH") == false){
//                println("これは抜ける!")
                break
            }
            let secondPost = Double(timeDifference)
//            print("仕込み:\(secondPost+(Double(cnt*postInterval)))")
            let myNotification: UILocalNotification = UILocalNotification()
            myNotification.alertBody = lm.getString(14)
            let musicNameStr:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
            myNotification.soundName = musicNameStr + ".caf"
            myNotification.timeZone = NSTimeZone.defaultTimeZone()
            myNotification.fireDate = NSDate(timeIntervalSinceNow: secondPost+(Double(cnt*postInterval)))
            UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
            cnt += 1
        }
        if(ud.boolForKey("PUSH") == false){
            NotificationUtil.pushDelete()
        }
    }
}

struct NotificationUtil {
    static func pushDelete(){
        //全てのローカル通知を削除する。（過去のローカル通知を削除する）
//        println("通知削除")
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}