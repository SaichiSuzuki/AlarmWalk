//
//  FirstClass.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/03/07.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

class FirstClass{
    func playBoyCheck() -> Bool{
        var myUserDefault:NSUserDefaults = NSUserDefaults()
        if(myUserDefault.boolForKey("PLAY_BOY")){ //2回目以降
            return true
        }
        else{ //初めて
            myUserDefault.setBool(true, forKey: "PLAY_BOY")
            myUserDefault.synchronize()
            //////////////////////////////////////
            ////////////// 初期設定 ///////////////
            //////////////////////////////////////
            //音楽設定
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            myUserDafault.setObject("You_wanna_fightC", forKey: "MUSIC_NAME")
            myUserDafault.synchronize()
            //言語設定
            myUserDafault.setInteger(1, forKey: "LANGUAGE")
            myUserDafault.synchronize()
            //歩数設定
            myUserDafault.setInteger(3, forKey: "LIFEFINAL")
            myUserDafault.setInteger(3, forKey: "LIFE")
            myUserDafault.synchronize()
            //オンオフ設定
            myUserDafault.setBool(false, forKey: "ONOFF")
            myUserDafault.synchronize()
            //ランダムかどうか設定
            myUserDafault.setBool(false, forKey: "IS_RAND")
            myUserDafault.synchronize()
            //セル位置設定
            myUserDafault.setInteger(0, forKey: "INDEX_PATH")
            myUserDafault.synchronize()
            //広告出すかどうか設定
            myUserDafault.setBool(false, forKey: "RegularUser_Ads")
            myUserDafault.synchronize()
            //テスト歩数計
            myUserDafault.setInteger(4, forKey: "TUTORIALLIFE")
            myUserDafault.synchronize()
            //音楽なってるか設定
            myUserDafault.setBool(false, forKey: "bgm")
            myUserDafault.synchronize()
            //1歩目か初期化
            myUserDafault.setBool(false, forKey: "HAJIMEIPPO_STILL") //1歩目か初期化
            myUserDafault.synchronize()
            //プッシュ通知初期化
            myUserDafault.setBool(false, forKey: "PUSH")
            myUserDafault.synchronize()
            //課金初期化
            myUserDafault.setBool(false, forKey: "PURCHASE_MUSIC")
            myUserDafault.synchronize()
            
            return false
        }
    }
}