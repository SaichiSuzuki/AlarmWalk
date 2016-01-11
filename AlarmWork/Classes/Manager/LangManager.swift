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
        lang.append(" ※Setting volume max and release the manner mode.\nWhen you press the clock icon in the on state,\n it repeated setting alarm and turn out blue")
        lang.append(" ※You should also be kept by hand if there is no pocket")
        lang.append(" ※When the count is reduced will sound\nFew times step is one step")
        lang.append("The upward the charging port\nPlease put it in pants pocket")
        lang.append("How to use AlarmWalk")
        //EditViewController
        lang.append("You stop when you enter the characters except '%'")
        lang.append("When get up...?")
        lang.append("Did you Manner mode is canceled?")
        lang.append(getWisdom())
        //AppDelegate
        lang.append("Please walked to start the app")
        lang.append("GoodMorning! Let's walking")
        //Purchase
        lang.append("Unlock music")
        lang.append("Connection error")
        lang.append("Connection situation is not good. After checking the radio wave environment, please try again.")
        // アラート
        lang.append("Caution")
        lang.append("Alarm stop method")
        lang.append("About push notification")
        lang.append("Use in alarm call")
        lang.append("10 foot looks like 1 count.\nYou should test if you want not bad feeling in the morning.")

        let myUserDafault:NSUserDefaults = NSUserDefaults()
        if(myUserDafault.integerForKey("LANGUAGE") == 1){ //Japanese
            //UiPageController
            lang[0] = ("1.時間をセット\n2.スイッチオン!")
            lang[1] = ("3.アラームが鳴ったら歩いて止める")
            lang[2] = ("Test Walk!!\n実際に歩いてみましょう")
            lang[3] = ("Let's happy life")
            lang[4] = (" ※マナーモードを解除して、音量を上げてください\nオンの状態で時計アイコンを押すと\n青色になり毎日同じ時間にセットされます")
            lang[5] = (" ※ポケットが無い場合太もも辺りで手で抑えてもいけます")
            lang[6] = (" ※カウントが減るとカチっと音が鳴ります\n数歩歩くと1歩として認識します")
            lang[7] = ("充電口を上向きに\nズボンの左右どちらかのポケットに入れて歩いてください")
            lang[8] = ("AlarmWalkの使い方")
            //EditViewController
            lang[9] = ("%を除く英数字を入力すると止まります")
            lang[10] = ("いつ起きるの？")
            lang[11] = ("マナーモード解除しましたか？")
            lang[12] = (getWisdom())
            //AppDelegate
            lang[13] = ("アプリを起動して歩いてください")
            lang[14] = ("GoodMorning! 歩いてください")
            //Purchase
            lang[15] = ("音楽解放")
            lang[16] = ("通信エラー")
            lang[17] = ("通信状況がよくありません。電波環境を確認後、再度お試しください。")
            // アラート
            lang[18] = ("重要")
            lang[19] = ("アラームの止め方")
            lang[20] = ("通知許可について")
            lang[21] = ("目覚ましのコールで使うため\n許可してください\n\nこれを許可すればアプリ起動中でなくても鳴るので安心してください")
            lang[22] = ("10歩で1カウントくらいです\n朝不快な思いをしないよう必ずテストしておいてください")
        }
    }
    func getWisdom() -> String{
        var serif = ""
        let ud:NSUserDefaults = NSUserDefaults()
        let serifEnglish:[String] = [
            "Let's happy life",
            "Did you wake up?",
            "Hello world",
//            "If today were the last day of my life,\nwould I want to do what I am about to do today?\nby Steve Jobs",
            "I feel good today~"
        ]
        let serifJapan:[String] = [
//            "おはようございます",
//            "Hello world",
//            "なんだか今日いけそうな気がする〜",
//            "もし今日が人生最後なら、\n今やろうとしていることは本当にやりたいことだろうか？\nby スティーブ・ジョブス",
//            "時には運に身を任せてみよう",
//            "人生にリハーサルはない\nby アシュレイ・ブリリアント",
//            "今日もなりたい自分になろう",
//            "今日は昨日より必ずいい日になる！",
//            "お前の道をすすめ\nby ダンテ・アリギエーリ",
//            "逆境はチャンスである\nby デニス・ウェイトレイ",
//            "無い物ねだりは無駄なこと\nby ケン・ケイエス・ジュニア",
//            "何でもやってみることが大切\nby ゲーテ",
//            "失敗なくして成功はない\nby サミュエル・スマイルス",
//            "何事もやってみることの大切さ\nby ロイド・ジョーンズ",
//            "過ちが人を大きくする\nby ウィリアム・グラッドストン",
            "Let's happy life",
            "おきましたか？"]
        if(ud.integerForKey("LANGUAGE") == 1){ //Japanese
            let serifCount:UInt32 = UInt32(serifJapan.count - 1)
            serif = serifJapan[Int(arc4random() % serifCount)]
        }else{ //English
            let serifCount:UInt32 = UInt32(serifEnglish.count - 1)
            serif = serifEnglish[Int(arc4random() % serifCount)]
        }
        return serif
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
    }
}