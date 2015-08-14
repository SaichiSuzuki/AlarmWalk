//
//  LangManager.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/04/02.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

class LangManager {
    var lang:[String] = []
    init(){ //English
        //UiPageController
        lang.append("1.Setting time\n2.Switch On!")
        lang.append("3.Stop walking If the alarm sounds")
        lang.append("Test Walk!!\nLet's try walking")
        lang.append("Let's happy life")
        lang.append(" ※Setting volume max\nand release the manner mode")
        lang.append(" ※You should also be kept by hand if there is no pocket")
        lang.append(" ※When the count is reduced will sound")
        lang.append("The upward the charging port\nPlease put it in pants pocket")
        lang.append("How to use AlarmWalk")
        //EditViewController
        lang.append("You stop when you enter the characters except '%'")
        lang.append("When get up...?")
        lang.append("Did you Manner mode is canceled?")
        lang.append("Let's happy life")
        //AppDelegate
        lang.append("Please walked to start the app")
        lang.append("GoodMorning! Let's walking")
        
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        if(myUserDafault.integerForKey("LANGUAGE") == 1){ //Japanese
            //UiPageController
            lang[0] = ("1.時間をセット\n2.スイッチオン!")
            lang[1] = ("3.アラームが鳴ったら歩いて止める")
            lang[2] = ("Test Walk!!\n実際に歩いてみましょう")
            lang[3] = ("Let's happy life")
            lang[4] = (" ※セットする際マナーモードを解除して、\n音量を上げてください")
            lang[5] = (" ※ポケットが無い場合太もも辺りで手で抑えてもいけます")
            lang[6] = (" ※カウントが減るとカチっと音が鳴ります")
            lang[7] = ("充電口を上向きに\nズボンのポケットに入れて歩いてください")
            lang[8] = ("AlarmWalkの使い方")
            //EditViewController
            lang[9] = ("%を除く英数字を入力すると止まります")
            lang[10] = ("いつ起きるの？")
            lang[11] = ("マナーモード解除しましたか？")
            lang[12] = ("おきましたか？")
            //AppDelegate
            lang[13] = ("アプリを起動して歩いてください")
            //add
            lang[14] = ("GoodMorning! 歩いてください")
        }
    }
    func getString(num:Int) ->String{
        return lang[num]
    }
}