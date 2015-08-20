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
    var musicName:[String] = []
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
        //Purchase
        lang.append("Unlock music")
        lang.append("Connection error")
        lang.append("Connection situation is not good. After checking the radio wave environment, please try again.")
        
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
            lang[14] = ("GoodMorning! 歩いてください")
            //Purchase
            lang[15] = ("音楽解放")
            lang[16] = ("通信エラー")
            lang[17] = ("通信状況がよくありません。電波環境を確認後、再度お試しください。")
        }
    }
    func getString(num:Int) ->String{
        return lang[num]
    }
    func getMusicName() ->[String]{
        setMusicName()
        return musicName
    }
    func setMusicName(){
        //English
        musicName.append("Fight")
        musicName.append("Smooth")
        musicName.append("Roll")
        musicName.append("Life")
        musicName.append("Random")
//        var myUserDafault:NSUserDefaults = NSUserDefaults()
//        if(myUserDafault.integerForKey("LANGUAGE") == 1){ //Japanese
//            musicName[0] = "Fight"
//            musicName[1] = "Smooth"
//            musicName[2] = "Road"
//            musicName[3] = "Life"
//            musicName[4] = "Random"
//        }
    }
}