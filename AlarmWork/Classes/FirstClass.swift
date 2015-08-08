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
        if(myUserDefault.boolForKey("PLAY_BOY")){
            return true
        }
        else{
            println("初期設定を行います")
            myUserDefault.setBool(true, forKey: "PLAY_BOY")
            myUserDefault.synchronize()
            
            //初期音楽設定
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            myUserDafault.setObject("You_wanna_fightC", forKey: "MUSIC_NAME")
            myUserDafault.synchronize()
            //初期言語設定
            myUserDafault.setInteger(1, forKey: "LANGUAGE")
            myUserDafault.synchronize()
            //初期歩数設定
            myUserDafault.setInteger(3, forKey: "LIFEFINAL")
            myUserDafault.setInteger(3, forKey: "LIFE")
            
            
            return false
        }
    }
}