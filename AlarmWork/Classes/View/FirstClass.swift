//
//  FirstClass.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/03/07.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

class FirstClass{
    /**
     初期値設定
     */
    func setDefault() {
        let ud = NSUserDefaults.standardUserDefaults()
        let dic: Dictionary = ["PLAY_BOY":0, "MUSIC_NAME":"You_wanna_fightC", "LANGUAGE":1, "LIFEFINAL":3, "LIFE":3, "ONOFF":false, "IS_RAND":false, "INDEX_PATH":0, "RegularUser_Ads":false, "TUTORIALLIFE":4,"bgm":false,"HAJIMEIPPO_STILL":false, "PUSH":false, "PURCHASE_MUSIC":false, "DAYLY_FLAG":false]
        ud.registerDefaults(dic) //ユーザーデフォルトに初期値を設定
        ud.synchronize()
    }
    /**
     データ初期化
     */
    func dataInit() {
        let ud = NSUserDefaults.standardUserDefaults()
        let dic: Dictionary = ["PLAY_BOY":0, "MUSIC_NAME":"You_wanna_fightC", "LANGUAGE":1, "LIFEFINAL":3, "LIFE":3, "ONOFF":false, "IS_RAND":false, "INDEX_PATH":0, "RegularUser_Ads":false, "TUTORIALLIFE":4,"bgm":false,"HAJIMEIPPO_STILL":false, "PUSH":false, "PURCHASE_MUSIC":false, "DAYLY_FLAG":false]
        ud.setValuesForKeysWithDictionary(dic)
        ud.synchronize()
    }
}