//
//  EditViewController.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/01/10.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import CoreLocation
import CoreMotion
import GoogleMobileAds

class EditViewController: UIViewController, UIPickerViewDelegate, CLLocationManagerDelegate{
    class func instance() -> Self {
        return self.init()
    }
    /**Admobインタースティシャルクラス宣言*/
    var ai:AdmobInterstitial!
    
    var cellView : CellViewController?
    
    //ユーザ設定
    var walkStep:Double = 0.1 //小幅の人は0.1//普通の人0.3 //大幅の人は0.8º //ランニングの場合は1.5
    var walkPoint = 5
    var roomwalk = 1 //室内(スリッパ)なら0.75//いや,全て0.8にしよう(accelyの1)
    
    //実験用
    var experimentFlag = false //データ収集
    var cwFlag = false //時間falseで表示
    
    var logStr = ""
    var logRemain = false
    
    
    /*パラメータ*/
    ////////////
    var elbowroomValue = 2 //ゆとり仕様
    //移動距離最初(ライフ)
    var lifePoints = 3
    //ジャイロ反応値アウト
    var gyroReaction = 4.5
    //バイブ感覚
    var vibInterval:Double = 3
    //暗号数
    var cryptographyNum = 20 //デフォルトは20
    //使用カラー
    var colorCode = "ffffff" //青系 4169E1
    // センターライン
    var toolBoxHeight: CGFloat = 40
    
    /*研究*/
    ////////////
    var myAccelYCounter = 100
    var myAccelY2Counter = 100
    var myAccelZCounter = 100
    var myJyroXCounter = 100
    var myJyroYCounter = 100
    var myJyroZCounter = 100
    var accelYf1 = false
    var accelYf2 = false
    var accelYf3 = false
    var accelZf1 = false
    var accelZf2 = false
    var accelZf3 = false
    var jyroXf1 = false
    var jyroXf2 = false
    var jyroXf3 = false
    var jyroZf1 = false
    var jyroZf2 = false
    var jyroZf3 = false
    
    /*加速度センサー*/
    ///////////////
    var myMotionManager: CMMotionManager!//加速度センサー
    var longitude: CLLocationDegrees!//緯度
    var latitude: CLLocationDegrees!//経度
    //    var accelX:Double = 0
    var accelY:Double = 0
    var accelZ:Double = 0
    
    /*ジャイロセンサー*/
    //////////
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    var gyroAuthorization = false
    var pastJyroX = 0
    var pastJyroZ = 0
    
    /*ピッカー*/
    //////////
    var myDatePicker: UIDatePicker!//ピッカー用意
    //現在時刻
    var now = NSDate()
    var formatter = NSDateFormatter()
    //設定時刻
    var mySelectedDate:NSString = ""
    var myDateFormatter = NSDateFormatter()
    var planTime = NSDate()
    //設定時間(秒)
    var planSec = 0
    //設定時間と現在時刻の差
    var timeDifference = 0
    //ピッカーいじったか
    var pickerUsedFlag = false
    //日またいだ日数
    var dayCount = 0
    
    
    /*フラグ準備*/
    ////////////
    //音楽なってるか
    var bgFlag = false
    var onOffFlag = false
    var musicSelectFlag = false
    //    var switchPushOverFlag = false
    var alartFlag = false
    var objectMakeFlag = false
    
    /*タイマー*/
    //////////
    //ラベル更新タイマー
    //    var labelTimer : NSTimer!
    var pushSetTimer : NSTimer!
    //バイブレーション開始タイマー
    var vibTimer : NSTimer!
    var alarmTimer : NSTimer!
    //マナーモード解除警告
    //    var mannerCautionTimer : NSTimer!
    
    /*その他*/
    //ユーザーデフォルト
    var ud:NSUserDefaults = NSUserDefaults()
    //音楽を司る変数
    var musicPlayer:MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
    //画面サイズ取得
    var winSize:CGRect!
    //現在時刻取得
    var calendar = NSCalendar.currentCalendar() //ただのカレンダー
    var comps:NSDateComponents! //カレンダーを使いやすくする型
    
    let volumeChange = SystemVolumeController()
    
    let session: AVAudioSession = AVAudioSession.sharedInstance()
    //    let mc = MusicController() //音楽コントローラ
    
    /*オブジェクト*/
    ///////
    var pointLabel:UILabel!//ポイントラベル
    //設定時刻ラベル
    var clockLabel: UILabel!//時間表示テキストフィールド
    //ギブアップボタン
    var giveUpBtn: UIButton!
    //音楽選択ボタン
    var musicSelectBtn: UIButton!
    //音楽選択ボタンの画像
    var myImageView: UIImageView!
    //音楽選択ウィンドウ
    //    var musicSelectView: UIView!
    //音楽鳴らすボタン
    var musicHearButton1: UIButton!
    var musicHearButton2: UIButton!
    var musicHearButton3: UIButton!
    var musicHearButton4: UIButton!
    var musicHearButton5: UIButton!
    var musicHearButton6: UIButton!
    //音楽選択ボタン
    var musicSelectButton1: UIButton!
    var musicSelectButton2: UIButton!
    var musicSelectButton3: UIButton!
    var musicSelectButton4: UIButton!
    var musicSelectButton5: UIButton!
    var musicSelectButton6: UIButton!
    //ステップバー
    var lifeStepper: UIStepper!
    //音量アイコン
    let musicStopCIImage = CIImage(image: UIImage(named: "soundIconZero.png")!)
    var musicStopUIImage:UIImageView!
    let musicPlayCIImage = CIImage(image: UIImage(named: "soundIconOne.png")!)
    var musicPlayUIImage:UIImageView!
    //距離アイコン
    //    let walkCIImage = CIImage(image: UIImage(named: "soundIconZero.png"))
    //    var walkUIImage:UIImageView!
    //    let runCIImage = CIImage(image: UIImage(named: "soundIconOne.png"))
    //    var runUIImage:UIImageView!
    //足跡アイコン
    let footImage = UIImage(named: "footPaint.png")
    var footUIImage:UIImageView!
    //チュートリアルアイコン
    //    let howtoCIImage = CIImage(image: UIImage(named: "infooff.png"))
    //チュートリアルオープン状態
    let howtoOpenImage = UIImage(named: "infoon.png")
    //アラームアイコン
    var bellOnImage = UIImage(named: "bellon.png")
    var bellOffImage = UIImage(named: "belloff.png")
    var bellImageView: UIImageView!
    //音楽選択ボタン
    let musicSelectCIImage = CIImage(image: UIImage(named: "musicLibrary.png")!)
    
    
    //チュートリアルボタン
    var tutorialBtn: UIButton!
    //歩幅調整スライダー
    //    var stepSlider:UISlider!
    //背景画像
    var backgroundImageView: UIImageView!
    //背景に仕様する画像
    // 画像を設定する.
    let bgInputImage = CIImage(image: UIImage(named: "bg.png")!)
    //アラームオンオフスイッチ
    var alarmSwitch: UISwitch = UISwitch()
    //マナーモード推奨バー
    var mannerModeLabel: UILabel = UILabel()
    //マナーモード推奨ボタン
    //    var mannerModeButton: UIButton = UIButton()
    
    //エフェクトビュー(隠すやつ)
    var effectView : UIVisualEffectView!
    
    //インタースティシャル広告準備
    var interstitial: GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-1645837363749700/5447856877")
    var interstitialData: GADInterstitial {
        get{
            return interstitial
        }
    }
    
    var pastStep = 0
    //ステップバー変更
    func stepperOneChanged(stepper: UIStepper){
        ud.setInteger(Int(stepper.value), forKey: "LIFEFINAL")
        ud.setInteger(Int(stepper.value), forKey: "LIFE")
        ud.synchronize()
        lifePoints = ud.integerForKey("LIFE")
        self.pointLabel.text = "\(self.lifePoints)"
        if(stepper.value > 13 && pastStep != 13){
            bgColorChange()
        }
        pastStep = Int(stepper.value)
    }
    
    //ステップスライダー動かす
    //    func onChangeValueStepSlider(sender : UISlider){
    //        walkStep = Double(sender.value)
    //        ud.setDouble(walkStep, forKey: "STEPFINAL")
    //        ud.synchronize()
    //        println(walkStep)
    //    }
    //オンオフスイッチ
    func onClickMySwitch(sender: UISwitch){
        NotificationUtil.pushDelete()
        let lm = LangManager()
        if sender.on == true {
            onOffFlag = true
            self.mannerModeLabel.text = lm.getString(11)
            bellImageView.image = bellOnImage
            clockLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            ud.setBool(true, forKey: "HAJIMEIPPO_STILL")
            ud.synchronize()
            UIView.animateWithDuration(1.0, animations: {() -> Void in
                self.mannerModeLabel.center = CGPoint(x: self.winSize.width/2,y: self.winSize.height/2 + 40);
                }, completion: {(Bool) -> Void in
                    self.mannerModeLabel.text = lm.getString(11);
            })
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "mannerLabelMoveReturn", userInfo: nil, repeats: false)
            AVAudioPlayerUtil.silencePlay();//再生
        } else {
            //            switchPushOverFlag = false
            onOffFlag = false
            //push通知終了
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setBool(false, forKey: "PUSH")
            ud.synchronize()
            bellImageView.image = bellOffImage
            clockLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
            UIView.animateWithDuration(1.0, animations: {() -> Void in
                self.mannerModeLabel.center = CGPoint(x: -self.mannerModeLabel.bounds.width,y: self.winSize.height/2 + 40)
                }, completion: {(Bool) -> Void in
                    self.mannerModeLabel.text = lm.getString(11)
            })
            AVAudioPlayerUtil.stop()
            ud.setBool(false, forKey: "DAYLY_FLAG")
            ud.synchronize()
        }
        ud.setBool(onOffFlag, forKey: "ONOFF")
        ud.synchronize()
        
        if ud.boolForKey("IS_RAND") {
            let rm = RandMusic()
            ud.setObject(rm.getRandMusic(), forKey: "MUSIC_NAME")
            ud.synchronize()
//            print(ud.stringForKey("MUSIC_NAME"))
        }
        
        let qualityOfServiceClass = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            // Backgroundで行いたい重い処理はここ
//            if sender.on == true {
//                self.settingAlarmTime()
//            }
            dispatch_async(dispatch_get_main_queue(), {
                // 処理が終わった後UIスレッドでやりたいことはここ
                if sender.on == true {
                    self.settingAlarmTime()
                    self.pushNotification()
                    self.volumeChange.systemVolumeChange(1.0) //システム音変更
                    NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "repeatManual", userInfo: nil, repeats: false)
                }
            })
        })
        
    }
    func repeatManual() {
        let ud = NSUserDefaults.standardUserDefaults()
        if !ud.boolForKey("VIRGIN_SWITCH") {
            ud.setBool(true, forKey: "VIRGIN_SWITCH")
            let alert = UIAlertController(title: "毎日繰り返し登録", message: "オンのとき時計アイコンをタップすると青くなり、繰り返しセットできます", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    //ギブアップボタン
    func giveUpBtnAction(sender: UIButton){
        let lm = LangManager()
        //textの表示はalertのみ。ActionSheetだとtextfiledを表示させようとすると
        //落ちます。
        var strCrypho = ""
        var strAnswer = ""
        //暗号生成
        for(var i=0;i<cryptographyNum;i++){
            let rand = Int(arc4random()%36)
            if(rand>9){
                //英語に変換
                let word = englishWordsConverter(rand)
                strCrypho = strCrypho + "\(word)" + "%"
                strAnswer = strAnswer + "\(word)"
            }
            else{
                strCrypho = strCrypho + "\(rand)" + "%"
                strAnswer = strAnswer + "\(rand)"
            }
        }
        let alert:UIAlertController = UIAlertController(title:strCrypho,
            message: lm.getString(9),
            preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction) -> Void in
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                let textFields:Array<UITextField>? =  alert.textFields 
                if textFields != nil {
                    for textField:UITextField in textFields! {
                        //各textにアクセス
                        if(strAnswer==textField.text){
                            self.musicStop()
                            self.openAlert("You are looser to yourself", messageStr: lm.getString(10),okStr:"No thank you")
                            if(self.vibTimer != nil){
                                self.vibTimer.invalidate() //バイブ終了
                            }
                        }
                    }
                }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        //textfiledの追加 実行した分textfiledを追加される。
        alert.addTextFieldWithConfigurationHandler({(text:UITextField) -> Void in
            text.placeholder = "Never Give Up"
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    //チュートリアルボタンアクション
    func tutorialBtnActionIn(sender: UIButton){
        if(experimentFlag == true){
            logRemain = true
        }
        sceneChange()
    }
    //    //チュートリアル外で離した時
    //    func tutorialBtnActionOut(sender: UIButton){
    //        //        tutorialBtn.backgroundColor = UIColor.hexStr("000000", alpha: 0.3)
    //        tutorialBtn.setImage(UIImage(CIImage: howtoCIImage), forState: .Normal)
    //    }
    //    //チュートリアル押した瞬間
    //    func tutorialBtnActionDown(sender: UIButton){
    //        //        tutorialBtn.backgroundColor = UIColor.hexStr("000000", alpha: 0.3)
    //        tutorialBtn.setImage(UIImage(CIImage: howtoOpenCIImage), forState: .Normal)
    //    }
    
    //画面が表示される直前
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navCon?.setNavigationBarHidden(true, animated: false)
        onOffFlag = ud.boolForKey("ONOFF")
//        let fc = FirstClass()
//        fc.dataInit()
    }
    
    //画面が表示された直後
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        AVAudioPlayerUtil.stopTest();//停止
        alertComeCheck() //アラートからきたかチェック
        if(alartFlag){
            alartFlag = false
//            let lm = LangManager()
//            self.openAlert("GoodMorning", messageStr: lm.getString(12), okStr: "OK") //アラート表示
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        splashAnimation()
        //課金リセット
        //        let ud = NSUserDefaults.standardUserDefaults()
        //        ud.setBool(false, forKey: "PURCHASE_MUSIC")
        //        ud.synchronize()
        //        removeFromParentViewController() //とりあえずなんか解放できるかも navigationbar使えなくなる
        self.ai = AdmobInterstitial(view: self) //Admobインタースティシャルインスタンスを生成
        //        println(ud.integerForKey("TUTORIALLIFE"))
        /*リセット！音楽鳴らしたり止めたり(テスト用)*/
        //        self.ud.setBool(true, forKey:≤ "HAJIMEIPPO_STILL")
        //        self.ud.synchronize()
        //        NotificationUtil.pushDelete()
        //        ud.synchronize()
        ///////////////////////////////
        pushAuthorization() //プッシュ通知許可
        firstContactCheck()
        winSize = self.view.bounds //画面サイズ取得
        self.view.backgroundColor = UIColor.lightGrayColor() //背景色
        bgFlag = ud.boolForKey("bgm")
        objectMake() //オブジェクト生成関数を実行してもよければ実行
        objectMove() //オブジェクト移動
        alarmUpdate() //1秒おきのアップデート1回最初に呼ぶ
        //        if(ud.integerForKey("TUTORIALLIFE") != 4){
        //        }
        timerStart() //タイマースタート
        myCoreMotion() //加速度センサー起動
        gyroInit() //ジャイロセンサー起動
        self.bgColorChange() //背景色いい感じにする
        if(bgFlag == true){
            AVAudioPlayerUtil.play();//再生
            NotificationUtil.pushDelete()
            //バイブも鳴らす
            vibTimer = NSTimer.scheduledTimerWithTimeInterval(vibInterval, target: self, selector: "vibUpdate", userInfo: nil, repeats: true)
            self.ud.setInteger(5, forKey: "TUTORIALLIFE") //5は通常稼働
            self.ud.synchronize()
            //一歩目限定イベント
            if(self.ud.boolForKey("HAJIMEIPPO_STILL") == true){
                AVAudioPlayerUtil.playMusicVolumeSetting(1.0)
            }
            else{
                AVAudioPlayerUtil.playMusicVolumeSetting(0.1)
            }
        }
        else{
            noMusicInit()
            if(onOffFlag){
                AVAudioPlayerUtil.silencePlay();//再生
            }
        }
        //現在時刻保存
        comps = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit],
            fromDate: now)
        ud.setInteger(comps.hour, forKey: "ONCEHOUR")
        ud.synchronize()
        ud.setInteger(comps.minute, forKey: "ONCEMINUTE")
        ud.synchronize()
        
        //割り込み用生成
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionInterrupted:", name: "AVAudioSessionInterruptionNotification", object: nil)
        //イヤホン用？
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionRouteChange:", name: "AVAudioSessionRouteChangeNotification", object: nil)
        //音量変更時
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getInstanceVolumeButtonNotification:", name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
        
        //        scrollView.layer.position = CGPoint(x: 0,y: winSize.height/2)
        
        //広告表示
        let n = Int(arc4random()%10)
        if(n == 0){
            ai.showAds(3)
        }
        
    }
    
    
    //タイマースタート
    func timerStart(){
        //メインUpdate
        alarmTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alarmUpdate", userInfo: nil, repeats: true)
    }
    
    ////////////////////////////////////////////////
    
    ////~~~~UPDATE~~~~///////////////////////////////
    
    ////////////////////////////////////////////////
    
    //メインUpdate(現在時刻取得、GPSスレッド起動、)
    func alarmUpdate(){
        //1秒毎に現在時刻取得
        getNowTime()
        let nowSecond = secondConverter(comps.hour, minute: comps.minute, second: comps.second)
        let setingTime = ud.integerForKey("PLANSECOND")
        //本来なるはずの時刻
        let timerPlanTime = ud.integerForKey("pastTime") + ud.integerForKey("differenceTime")
        if(timerPlanTime>=86400){
            timerPlanTime - 86400
        }
        //アラームセットして画面つけていてセットタイムになった場合
        if((nowSecond>=timerPlanTime || nowSecond==setingTime) && bgFlag==false && onOffFlag==true){
            //            println("アラーム開始")
            musicStart()
        }
//        if(bgFlag == true && comps.second == 0){
//            setTime(comps.hour, m: comps.minute) //時間ラベル更新
//        }
        inclinateGyroContinue() //加速度、ジャイロチェック
    }
    //アラートから来たかチェック
    internal func alertComeCheck(){
        //        println("チェック")
        now = NSDate()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeStyle = .MediumStyle
        //現在時刻を過去時刻に保存
        calendar = NSCalendar.currentCalendar()
        comps = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit],
            fromDate: now)
        let nowSecond = secondConverter(comps.hour, minute: comps.minute, second: comps.second)
        let pastTime = ud.integerForKey("pastTime") //スイッチオンした時間
        var differenceTime = ud.integerForKey("differenceTime")
        let planTime = ud.integerForKey("PLANSECOND") //設定時間
        //        var timerPlanTime = pastTime + differenceTime //設定時間
        //        if(timerPlanTime>=86400){
        //            timerPlanTime - 86400
        //        }
        //        println("設定時間:\(timerPlanTime)秒")
        //        println("現在時刻:\(nowSecond)秒")
        onOffFlag = ud.boolForKey("ONOFF")
        //        println("ONOFFflag:\(onOffFlag)")
        if(pastTime > nowSecond){
            let diff = pastTime - nowSecond
            dayCount += (diff / 86400)+1
        }
        //アラートからきた場合
        if(planTime<=(nowSecond+(86400*dayCount)) && bgFlag==false && onOffFlag==true){
            //            println("アラートからきましたね")
            musicStart()
        }
        dayCount = 0
    }
    
    ////////////////////////////////////////////////
    
    ////~~~~CoreMotion~~~~///////////////////////////////
    
    ////////////////////////////////////////////////
    
    func myCoreMotion(){
        // MotionManagerを生成.
        myMotionManager = CMMotionManager()
        // 更新周期を設定.
        myMotionManager.accelerometerUpdateInterval = 0.3
        // 加速度の取得を開始.
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
            guard accelerometerData != nil else {
                print("There was an error: \(error)")
                return
            }
            //現在加速度取得しテキスト表示
            //            self.accelX = accelerometerData.acceleration.x
            self.accelY = accelerometerData!.acceleration.y
            self.accelZ = accelerometerData!.acceleration.z
            //実験ならログを残す
            if(self.logRemain == false && self.experimentFlag == true){
                print("\(accelerometerData!.acceleration.x):", terminator: "")
                print("\(accelerometerData!.acceleration.y):", terminator: "")
                print("\(accelerometerData!.acceleration.z)X", terminator: "")
            }
            /*新機能Accel研究*/
            //accelY研究
            if(self.accelYf3 == true && self.accelY>=1 && self.accelY<=4){
                self.myAccelYCounter = self.elbowroomValue
            }
            if(self.accelYf2 == true && self.accelY<=1 && self.accelY>=(-2)){
                self.accelYf3 = true
            }
            if(self.accelY>=1 || self.accelY<=(-2)){
                self.accelYf3 = false
            }
            if(self.accelYf1 == true && self.accelY>=1 && self.accelY<=4){
                self.accelYf2 = true
            }
            if(self.accelY<=1 || self.accelY>=4){
                self.accelYf2 = false
            }
            if(self.accelY<=1 && self.accelY>=(-2)){
                self.accelYf1 = true
            }
            else {
                self.accelYf1 = false
            }
            //accelY2研究
            if(self.accelY>=1.4 || self.accelY<=0.8){ //NGゾーンに入っていなかったら
                self.myAccelY2Counter = 100
            }
            else{
                self.myAccelY2Counter -= 1 //90以下になったらダメだね
            }
            //accelZ研究
            if(self.accelZf3 == true && self.accelZ>=(-0.1) && self.accelZ<=3){
                self.myAccelZCounter = 2
            }
            if(self.accelZf2 == true && self.accelZ<=(-0.1) && self.accelZ>=(-3)){
                self.accelZf3 = true
            }
            if(self.accelZ>=(-0.1) || self.accelZ<=(-3)){
                self.accelZf3 = false
            }
            if(self.accelZf1 == true && self.accelZ>=(-0.1) && self.accelZ<=3){
                self.accelZf2 = true
            }
            if(self.accelZ<=(-0.1) || self.accelZ>=3){
                self.accelZf2 = false
            }
            if(self.accelZ<=(-0.1) && self.accelZ>=(-3)){
                self.accelZf1 = true
            }
            else {
                self.accelZf1 = false
            }
            
            //TUTORIALLIFE
            //2以下:testwalk中 4:鳴ってほしくない 5:タイトルで鳴ってる
            //全検証突破した為OK牧場 //TUTORIALLIFE本来は3、実験は100
            if(self.myAccelZCounter != 100 && self.myAccelYCounter != 100 && self.myJyroXCounter != 100 && self.myJyroYCounter != 100 && self.ud.integerForKey("TUTORIALLIFE") != 4){
                self.sensorInit()
                //アラームシーンの場合
                if(self.ud.integerForKey("TUTORIALLIFE") == 5){
                    self.lifePoints = self.ud.integerForKey("LIFE")
                    self.lifePoints -= 1 //ライフを減らす
                    self.ud.setInteger(self.lifePoints, forKey: "LIFE")
                    self.ud.synchronize()
                    
                    //効果音再生
                    AVAudioPlayerUtil.playSE();//再生
                    //ライフポイントが尽きたら
                    if(self.lifePoints<1 && self.bgFlag==true){
                        NotificationUtil.pushDelete()
                        if(self.vibTimer != nil){
                            self.vibTimer.invalidate() //バイブ終了
                        }
                        AVAudioPlayerUtil.playFinish();//終了音再生
                        self.alartFlag = true
                        self.ud.setInteger(4, forKey: "TUTORIALLIFE")
                        self.ud.synchronize()
                        self.ud.setInteger(1, forKey: "ZEBRA_LIFE")
                        self.ud.synchronize()
//                        self.ai.showAds()
                        //バッジの数を0にする.
                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                        dispatch_async(dispatch_get_main_queue(), {
                            self.musicStop()
                            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "morningAlart", userInfo: nil, repeats: false)
                        })
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.pointLabel.text = "\(self.lifePoints)"
                        self.bgColorChange() //背景色いい感じにする
                    })
                    //一歩目限定イベント
                    if(self.ud.boolForKey("HAJIMEIPPO_STILL") == true){
                        self.ippome()
                    }
                    
                }
                    //チュートリアルシーンの場合
                else if(self.ud.integerForKey("TUTORIALLIFE") <= 2){
                    //tutorialのライフ減らす
                    var tLife = self.ud.integerForKey("TUTORIALLIFE")
                    tLife -= 1
                    self.ud.setInteger(tLife, forKey: "TUTORIALLIFE")
                    self.ud.synchronize()
                    //効果音再生
                    AVAudioPlayerUtil.playSE();//再生
                }
            }
            /*-------------*/
        }
    }
    
    func morningAlart() {
        let lm = LangManager()
        self.openAlert("GoodMorning", messageStr: lm.getString(12), okStr: "OK") //アラート表示
    }
    
    //一歩目限定イベント
    func ippome(){
        self.ud.setBool(false, forKey: "HAJIMEIPPO_STILL")
        self.ud.synchronize()
        volumeChange.systemVolumeChange(0.5) //システム音変更
        AVAudioPlayerUtil.playMusicVolumeSetting(0.1)
    }
    
    ////////////////////////////////////////////////
    ////~~~~ジャイロセンサー~~~~///////////////////////
    ////////////////////////////////////////////////
    
    func gyroInit(){
        if myMotionManager.gyroAvailable {
            myMotionManager.deviceMotionUpdateInterval = 0.3;
            myMotionManager.startDeviceMotionUpdates()
            myMotionManager.gyroUpdateInterval = 0.2
            myMotionManager.startGyroUpdatesToQueue(NSOperationQueue()) { (gyroData: CMGyroData?, error: NSError?) -> Void in
                guard gyroData != nil else {
                    print("There was an error: \(error)")
                    return
                }
                self.outputRotationData(gyroData!.rotationRate)
            }
        } else {
            // alert message
            let alert = UIAlertController(title: "No gyro", message: "Get a Gyro", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func outputRotationData(rotation:CMRotationRate)
    {
        if fabs(rotation.x) > fabs(currentMaxRotX)
        {
            currentMaxRotX = rotation.x
        }
        if fabs(rotation.y) > fabs(currentMaxRotY)
        {
            currentMaxRotY = rotation.y
        }
        if fabs(rotation.z) > fabs(currentMaxRotZ)
        {
            currentMaxRotZ = rotation.z
        }
        self.logStr = self.logStr + "\(rotation.x):"
        self.logStr = self.logStr + "\(rotation.y):"
        self.logStr = self.logStr + "\(rotation.z)X"
        
        
        /*新機能jyro研究*/
        //jyroX研究
        if(self.jyroXf3 == true && rotation.x>=self.walkStep && rotation.x<=4.5){
            self.myJyroXCounter = self.elbowroomValue
        }
        if(self.jyroXf2 == true && rotation.x<=(-self.walkStep) && rotation.x>=(-4.5)){
            self.jyroXf3 = true
        }
        if(rotation.x>=self.walkStep || rotation.x<=(-4.5)){
            self.jyroXf3 = false
        }
        if(self.jyroXf1 == true && rotation.x>=self.walkStep && rotation.x<=4.5){
            self.jyroXf2 = true
        }
        if(rotation.x<=(-self.walkStep) || rotation.x>=4.5){
            self.jyroXf2 = false
        }
        if(rotation.x<=(-self.walkStep) && rotation.x>=(-4.5)){
            self.jyroXf1 = true
        }
        else {
            self.jyroXf1 = false
        }
        //jyroY研究
        if(rotation.y >= 2 || rotation.y <= (-2)){ //2より外ならおっけー
            self.myJyroYCounter = self.elbowroomValue
        }
        //jyroZ研究
        let shift = 1.0
        if(self.jyroZf3 == true && rotation.z<(rotation.x - shift) && rotation.z<(rotation.y - shift)){
            self.myJyroZCounter = self.elbowroomValue
        }
        if(self.jyroZf2 == true && rotation.z>(rotation.x + shift) && rotation.z>(rotation.y + shift)){
            self.jyroZf3 = true
        }
        if(rotation.z<rotation.x || rotation.z<rotation.y){
            self.jyroZf3 = false
        }
        if(self.jyroZf1 == true && rotation.z<(rotation.x - shift) && rotation.z<(rotation.y - shift)){
            self.jyroZf2 = true
        }
        if(rotation.z>rotation.x || rotation.z>rotation.y){
            self.jyroZf2 = false
        }
        if(rotation.z>(rotation.x + shift) || rotation.z>(rotation.y + shift)){
            self.jyroZf1 = true
        }
        else {
            self.jyroZf1 = false
        }
        //jyroZ研究2 //歩いてる感じをその場で再現を防止
        if(rotation.z >= 2.5 || rotation.z <= (-2.5)){
            self.myJyroZCounter = 2
        }
        
        //NGな行為な為初期化する
        //gyroY振りすぎ || ←強く降るの防止 || 上着ポケット入れる際の防止 || ←同じ || accecY2入り続けたら || 俺いい感上下防止策 || ポケット落とししたな
        if(rotation.y < (-gyroReaction) || rotation.y > gyroReaction || self.accelY < 0 || self.myAccelY2Counter < 94 || (self.accelY >= 1.5 && myJyroYCounter == 100) && self.myJyroZCounter != 100){
            
            //            if(experimentFlag == false){
            //                if(rotation.y < (-gyroReaction) || rotation.y > gyroReaction){
            //                    println("gyroY振りすぎ")
            //                }
            //                //            if(self.accelX<(-0.4)){
            //                //                println("上着のポケットに入れる動き")
            //                //            }
            //                if(self.accelY < 0){
            //                    println("ポケット入れたな")
            //                }
            //                //            if(self.myAccelY2Counter < 94){
            //                //                println("ケツ叩きしたな\(self.myAccelY2Counter)")
            //                //            }
            //                if(self.accelY >= 1.5 && myJyroYCounter == 100){
            //                    println("いい感じ上下防止")
            //                }
            //                if(self.myJyroZCounter != 100){
            //                    println("ポケット落とししたな\(self.myJyroZCounter)")
            //                }
            //            }
            
            sensorInit()
        }
        /*-------------*/
        
        var attitude = CMAttitude()
        var motion = CMDeviceMotion()
    }
    //研究パラメータ初期化
    func sensorInit(){
        self.myAccelYCounter = 100
        self.myAccelZCounter = 100
        self.myJyroXCounter = 100
        self.myJyroYCounter = 100
        self.accelYf1 = false
        self.accelYf2 = false
        self.accelYf3 = false
        self.accelZf1 = false
        self.accelZf2 = false
        self.accelZf3 = false
        self.jyroXf1 = false
        self.jyroXf2 = false
        self.jyroXf3 = false
        self.jyroZf1 = false
        self.jyroZf2 = false
        self.jyroZf3 = false
    }
    
    ////////////////////////////////////////////////
    
    ////~~~~DatePicker~~~~///////////////////////////////
    
    ////////////////////////////////////////////////
    
    
    //DatePickerが選ばれた際に呼ばれる.
    func onDidChangeDate(sender: UIDatePicker){
        //ピッカー時刻取得
        myDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "HH:mm"
        myDateFormatter.timeStyle = .MediumStyle
        mySelectedDate = myDateFormatter.stringFromDate(sender.date)
        //スイッチフラグ取得
        //        onOffFlag = ud.boolForKey("ONOFF")
        pickerUsedFlag = true
        //オンならアラームセット
        if(onOffFlag==true){
            settingAlarmTime()
            self.pushNotification()
        }
        else{
            planTime = myDateFormatter.dateFromString(mySelectedDate as String)!
//            let comp = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit], fromDate: planTime)
//            setTime(comp.hour, m: comp.minute) //時間ラベル更新
        }
    }
    
    /**
     アプリ内でのアラームセットする
     */
    func settingAlarmTime(){
        
        planTime = myDateFormatter.dateFromString(mySelectedDate as String)!
        
        getNowTime()
        let planComps = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit], fromDate: planTime)
        //ピッカー使われてない場合
        if(pickerUsedFlag==false){
            planComps.hour = ud.integerForKey("ONCEHOUR")
            planComps.minute = ud.integerForKey("ONCEMINUTE")
        }
        setClockLabel(planComps.hour, m: planComps.minute) //時間ラベル更新
        updateSettingTimeDifference() // 設定時間後の時間を更新する
    }
    
    // 設定時間後の時間を更新
    func updateSettingTimeDifference() {
        let nowSecond = secondConverter(comps.hour, minute: comps.minute, second: comps.second)
        let planComps = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit], fromDate: planTime)
        //設定時刻を秒で取得
        var planTimeSecond = secondConverter(planComps.hour, minute: planComps.minute, second: 0)
        if(nowSecond>=planTimeSecond){ //予定時刻が0時をまたぐ場合
            planTimeSecond += 86400
        }
        timeDifference = planTimeSecond - nowSecond
        if(timeDifference<0){ //現在時間より数字的に前だった場合
            timeDifference = Int(numberConversion(Double(timeDifference)))
            timeDifference = 86400 - timeDifference
        }
        ud.setInteger(nowSecond, forKey: "pastTime")
        ud.synchronize()
        ud.setInteger(timeDifference, forKey: "differenceTime")
        ud.synchronize()
        ud.setInteger(planTimeSecond, forKey: "PLANSECOND")
        ud.synchronize()
        timeSave() //設定時刻の保存
    }
    
    //通知仕込む
    func pushNotification(){
//        print("\(timeDifference)秒後に仕込みます")
        let notifi = NotificationManager(diff: timeDifference)
        notifi.postAlarm()
    }
    
    //giveupアラート仕込み処理
    func giveUpAlartCreate(){
        while(cryptographyNum > 0){
            cryptographyNum -= 0
        }
    }
    
    func inclinateGyroContinue(){
        
        //加速度Yオッケーサインでたら1秒おっけー
        if(myAccelYCounter <= elbowroomValue){
            myAccelYCounter -= 1
        }
        if(myAccelYCounter < 1){
            myAccelYCounter = 100
        }
        //加速度Zオッケーサインでたら1秒おっけー
        if(myAccelZCounter <= elbowroomValue){
            myAccelZCounter -= 1
        }
        if(myAccelZCounter < 1){
            myAccelZCounter = 100
        }
        //ジャイロXオッケーサインでたら1秒おっけー
        if(myJyroXCounter <= elbowroomValue){
            myJyroXCounter -= 1
        }
        if(myJyroXCounter < 1){
            myJyroXCounter = 100
        }
        //ジャイロYNGサインでたら2秒おっけー
        if(myJyroYCounter <= elbowroomValue){
            myJyroYCounter -= 1
        }
        if(myJyroYCounter < 1){
            myJyroYCounter = 100
        }
        //ジャイロZオッケーサインでたら1秒NG
        if(myJyroZCounter <= 2){
            myJyroZCounter -= 1
        }
        if(myJyroZCounter < 1){
            myJyroZCounter = 100
        }
    }
    
    func getNowTime(){
        now = NSDate()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeStyle = .MediumStyle
        //現在時刻を過去時刻に保存
        calendar = NSCalendar.currentCalendar()
        comps = calendar.components([NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit],
            fromDate: now)
    }
    ////////////////////////////////////////////////
    ////~~~~オブジェクト生成~~~~///////////////////////////////
    ////////////////////////////////////////////////
    func objectMake(){
        if objectMakeFlag {
            return
        }
        objectMakeFlag = true
        let lm = LangManager()
        onOffFlag = ud.boolForKey("ONOFF")
        
        // 設定時間ラベル作成
        let hou = ud.integerForKey("SET_HOUR")
        let min = ud.integerForKey("SET_MINUTE")
        clockLabel = UILabel(frame: CGRectMake(0,0,winSize.width,winSize.height))
        clockLabel.layer.position = CGPoint(x: winSize.width/2,y: winSize.height/2 + 100);
        clockLabel.textAlignment = NSTextAlignment.Center
        clockLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 80)
        clockLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        getNowTime()
        setClockLabel(comps.hour, m: comps.minute) //時間ラベル更新
        //        println("現在時間セット\(comps.hour):\(comps.minute)")
//        if(onOffFlag == true && bgFlag == false){
        if(onOffFlag == true){
            //            println("予定時間セット\(hou):\(min)")
            setClockLabel(hou, m: min) //時間ラベル更新
        }
        
        // DatePickerを生成する.
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = UIDatePickerMode.Time;//ここを変えればタイマーカウント等も作成できます。
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        myDatePicker.frame = CGRectMake(0, 0, winSize.width,winSize.height/2)
        myDatePicker.timeZone = NSTimeZone.localTimeZone()
        myDatePicker.backgroundColor = UIColor.grayColor()
        myDatePicker.layer.shadowOpacity = 0.5
        myDatePicker.layer.opacity = 0.6
        myDatePicker.tintColor = UIColor.redColor()
        myDatePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        
        // 値が変わった際のイベントを登録する.
        myDatePicker.addTarget(self, action: "onDidChangeDate:", forControlEvents: .ValueChanged)
        //スイッチ準備
        alarmSwitch.layer.position = CGPoint(x: 30, y: winSize.height/2 - 2)
        alarmSwitch.onTintColor = UIColor.hexStr("#6286c0", alpha: 1)
        alarmSwitch.on = onOffFlag
        // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
        alarmSwitch.addTarget(self, action: "onClickMySwitch:", forControlEvents: UIControlEvents.ValueChanged)
        
        //残り歩数ラベル生成
        pointLabel = UILabel(frame: CGRect(x: 0, y: 0, width: winSize.width, height: 30))
        pointLabel.textAlignment = NSTextAlignment.Center
        //        pointLabel.font = UIFont.boldSystemFontOfSize(20)
        pointLabel.font = UIFont.systemFontOfSize(20)
        //        pointLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        pointLabel.layer.position = CGPoint(x: winSize.width/2 + 80, y:winSize.height/2 - 2)
        pointLabel.layer.zPosition = 2
        pointLabel.textColor = UIColor.hexStr(colorCode, alpha: 1)
        lifePoints = ud.integerForKey("LIFE")
        pointLabel.text = "\(lifePoints)"
        
        //ギブアップボタン作成
        giveUpBtn = UIButton(frame: CGRectMake(160, 30, 100, 50))
        giveUpBtn.setTitle("give up!!", forState: .Normal)
        giveUpBtn.addTarget(self, action: "giveUpBtnAction:", forControlEvents:.TouchUpInside)
        giveUpBtn.layer.borderWidth = 1
        giveUpBtn.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        giveUpBtn.layer.cornerRadius = 3
        giveUpBtn.layer.position = CGPoint(x: winSize.width/2,y: 150);
        giveUpBtn.layer.zPosition = -1
        //        giveUpBtn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        //音楽選択ボタン作成
        musicSelectBtn = UIButton(frame: CGRectMake(0, 0, 40, 40))
        //        musicSelectBtn.setTitle("♪", forState: .Normal)
        musicSelectBtn.addTarget(self, action: "moveCellView", forControlEvents:.TouchUpInside)
        musicSelectBtn.layer.position = CGPoint(x: winSize.width - 20, y: winSize.height/2 + 50);
        musicSelectBtn.layer.zPosition = 2
        musicSelectBtn.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.3)
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRectMake(0,0,20,20))
        let myImage = UIImage(named: "musicLibrary.png")
        myImageView.layer.zPosition = 2
        myImageView.image = myImage
        myImageView.layer.position = CGPoint(x: winSize.width - 20,y: winSize.height/2 + 50)
        
        // Stepperの作成する
        lifeStepper = UIStepper()
        //lifeStepper.backgroundColor = UIColor.whiteColor()
        lifeStepper.addTarget(self, action: "stepperOneChanged:", forControlEvents: UIControlEvents.ValueChanged)
        lifeStepper.layer.cornerRadius = 1
        //        lifeStepper.setcolor = UIColor.hexStr(colorCode, alpha: 1)
        lifeStepper.tintColor = UIColor.hexStr(colorCode, alpha: 1)
        lifeStepper.layer.position = CGPoint(x: winSize.width/2 - 5,y: winSize.height/2 - 2);
        // 最小値, 最大値, 規定値の設定をする.
        lifeStepper.minimumValue = 3
        lifeStepper.maximumValue = 15
        lifeStepper.value = Double(ud.integerForKey("LIFEFINAL"))
        // ボタンを押した際に動く値の.を設定する.
        lifeStepper.stepValue = 1
        
        //枠組み作成
        //枠の見た目作成する.
        let flameLabel = UIView(frame: CGRectMake(0,0,winSize.width,toolBoxHeight))
        flameLabel.backgroundColor = UIColor.hexStr("34495e", alpha: 1)
        flameLabel.layer.opacity = 0.8
        flameLabel.layer.position = CGPoint(x: winSize.width/2, y:winSize.height/2 - 2)
        
        //音量アイコン
        musicStopUIImage = UIImageView(frame: CGRectMake(0, 0, 35, 35))
        musicStopUIImage.image = UIImage(CIImage: musicStopCIImage!)
        musicStopUIImage.layer.position = CGPoint(x: 25, y: winSize.height - 20)
        musicPlayUIImage = UIImageView(frame: CGRectMake(0, 0, 35, 35))
        musicPlayUIImage.image = UIImage(CIImage: musicPlayCIImage!)
        musicPlayUIImage.layer.position = CGPoint(x: winSize.width - 25, y: winSize.height - 20)
        
        //足跡アイコン
        footUIImage = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        footUIImage.image = footImage
        footUIImage.layer.position = CGPoint(x: winSize.width/2 + 58, y: winSize.height/2 - 2)
        footUIImage.layer.zPosition = 2
        
        //アラームアイコン
        bellImageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        bellImageView.image = bellOffImage
        bellImageView.layer.position = CGPoint(x: 70, y: winSize.height/2 - 2)
        bellImageView.layer.zPosition = 2
        bellImageView.userInteractionEnabled = true
        if ud.boolForKey("DAYLY_FLAG") {
            bellImageView.image = UIImage(named: "belldayly.png")
        }
        
        // アラームアイコンをタップ可にする
        let bellTapBtn = UITapGestureRecognizer(target: self, action: "belltap")
        
        //チュートリアルボタン作成
        tutorialBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        tutorialBtn.layer.position = CGPoint(x: winSize.width - 20, y:winSize.height/2 - 2)
        tutorialBtn.layer.zPosition = 2
        tutorialBtn.setImage(howtoOpenImage, forState: .Normal)
        tutorialBtn.addTarget(self, action: "tutorialBtnActionIn:", forControlEvents:.TouchUpInside)
        
        // UIImageViewを作成する.
        backgroundImageView = UIImageView(frame: CGRectMake(0, 0, winSize.width, winSize.height))
        backgroundImageView.image = UIImage(CIImage: bgInputImage!)
        backgroundImageView.layer.opacity = 0.8
        
        //マナーモード推奨ラベル
        mannerModeLabel = UILabel(frame: CGRectMake(0,0,winSize.width*2/3,30))
        mannerModeLabel.backgroundColor = UIColor.hexStr("CC0000", alpha: 1)
        mannerModeLabel.text = lm.getString(11)
        mannerModeLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mannerModeLabel.textAlignment = .Center
        mannerModeLabel.font = UIFont.systemFontOfSize(12)
        mannerModeLabel.layer.cornerRadius = 2
        mannerModeLabel.layer.opacity = 0.6
        mannerModeLabel.layer.position = CGPoint(x: -self.mannerModeLabel.bounds.width, y:winSize.height/2 + 40)
        
        //Blurエフェクト生成
        var effect : UIBlurEffect!
        effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        //音量スライダー生成
        let wrapperView = MPVolumeView(frame: CGRectMake(0, 0, winSize.width-100, 50))
        wrapperView.layer.position = CGPoint(x: winSize.width/2, y:winSize.height - 5)
        wrapperView.tintColor = UIColor.whiteColor()
        
        // タップを認識.
        let myTap = UITapGestureRecognizer(target: self, action: "anyTapGesture:")
        
        
        // Viewに追加する.
        self.view.addSubview(backgroundImageView) //背景
        self.addVirtualEffectView(effect)
        self.view.addSubview(myDatePicker)
        self.view.addSubview(musicStopUIImage)
        self.view.addSubview(musicPlayUIImage)
        self.view.addSubview(flameLabel)
        self.view.addSubview(lifeStepper)
        self.view.addSubview(giveUpBtn)
        self.view.addSubview(tutorialBtn)
        self.view.addSubview(musicSelectBtn)
        self.view.addSubview(myImageView)
        
        self.view.addSubview(pointLabel)
        self.view.addSubview(footUIImage)
        self.view.addSubview(bellImageView)
        bellImageView.addGestureRecognizer(bellTapBtn)
        self.view.addSubview(alarmSwitch)
        
        self.view.addSubview(clockLabel)
        self.view.addSubview(wrapperView)
        self.view.addSubview(mannerModeLabel)
        
        self.view.addGestureRecognizer(myTap)
    }
    
    func belltap() {
        if alarmSwitch.on {
            let ud = NSUserDefaults.standardUserDefaults()
            if ud.boolForKey("DAYLY_FLAG") {
                ud.setBool(false, forKey: "DAYLY_FLAG")
                ud.synchronize()
                bellImageView.image = UIImage(named: "bellon.png")
            } else {
                ud.setBool(true, forKey: "DAYLY_FLAG")
                ud.synchronize()
                bellImageView.image = UIImage(named: "belldayly.png")
            }
        }
    }
    
    func moveCellView(){
        self.cellView = CellViewController();
        self.navigationController?.pushViewController(self.cellView!, animated: true)
    }
    
    func objectMove(){
        if !objectMakeFlag {
           winSize = self.view.bounds //画面サイズ取得
           objectMake()
        }
        //音楽鳴ってれば
        if(bgFlag==true){
            myDatePicker.layer.zPosition = -1 //ピッカーさよなら
            myDatePicker.layer.position = CGPoint(x: winSize.width * 2,y: winSize.height * 2);
            giveUpBtn.layer.zPosition = 3 //ギブアップボタン浮上
            giveUpBtn.layer.hidden = false
            effectView.layer.zPosition = 1 //Blur浮上
            bellImageView.layer.zPosition = -1 //アラームアイコンさよなら
            musicSelectBtn.layer.zPosition = -1
            myImageView.layer.zPosition = -1
            
            //押せるようにする
            giveUpBtn.enabled = true
            //押せないようにする
            alarmSwitch.enabled = false
            lifeStepper.enabled = false
            myDatePicker.enabled = false
            musicSelectBtn.enabled = false
        }
            //音楽鳴ってなければ
        else{
            myDatePicker.layer.zPosition = 1 //ピッカー浮上
            myDatePicker.layer.position = CGPoint(x: winSize.width/2,y: winSize.height/2 - myDatePicker.bounds.height/2  - (toolBoxHeight/2) - 2);
            giveUpBtn.layer.zPosition = -1 //ギブアップボタンさよなら
            giveUpBtn.layer.hidden = true
            effectView.layer.zPosition = -1 //Blurさよなら
            bellImageView.layer.zPosition = 2 //アラームアイコン浮上
            musicSelectBtn.layer.zPosition = 1
            myImageView.layer.zPosition = 1
            
            //押せるようにする
            alarmSwitch.enabled = true
            lifeStepper.enabled = true
            myDatePicker.enabled = true
            musicSelectBtn.enabled = true
            //押せないようにする
            giveUpBtn.enabled = false
        }
        
        //アラームオンなら
        if(onOffFlag == true){
            let ud = NSUserDefaults.standardUserDefaults()
            if ud.boolForKey("DAYLY_FLAG") {
                bellImageView.image = UIImage(named: "belldayly.png")
            } else {
                bellImageView.image = bellOnImage
            }
            clockLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        else {
            bellImageView.image = bellOffImage
            clockLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        }
        bgColorChange()
    }
    
    //背景色いい感じにする
    func bgColorChange(){
        
        // カラーエフェクトを指定してCIFilterをインスタンス化する.
        let myColorFilter = CIFilter(name: "CIColorCrossPolynomial")
        
        // イメージを設定する.
        myColorFilter!.setValue(bgInputImage, forKey: kCIInputImageKey)
        
        // RGBの変換値を作成する.
        var r: [CGFloat]!
        var g: [CGFloat]!
        var b: [CGFloat]!
        if(lifePoints>14){ //満タン15で緑
            r = [0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.1, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
        else if(lifePoints>2){ //3以上で青
            r = [0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.2, CGFloat(lifePoints/50), 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
        else { //2以下で赤
            r = [0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            g = [0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            b = [0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
        
        // 値の調整をする.
        myColorFilter!.setValue(CIVector(values: r, count: 10), forKey: "inputRedCoefficients")
        myColorFilter!.setValue(CIVector(values: g, count: 10), forKey: "inputGreenCoefficients")
        myColorFilter!.setValue(CIVector(values: b, count: 10), forKey: "inputBlueCoefficients")
        
        // フィルターで処理した画像をアウトプットする.
        let myOutputImage : CIImage = myColorFilter!.outputImage!
        
        // 再びUIView処理済み画像を設定する.
        backgroundImageView.image = UIImage(CIImage: myOutputImage)
        
        // 再描画をおこなう.
        backgroundImageView.setNeedsDisplay()
    }
    
    
    //Blurエフェクト表示
    func addVirtualEffectView(effect : UIBlurEffect!){
        // Blurエフェクトを適用するEffectViewを作成.
        effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRectMake(0, 0, winSize.width, winSize.height/2 + 25)
        //        effectView.layer.position = CGPointMake(0,0)
        //        effectView.layer.masksToBounds = true
        effectView.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.2)
        effectView.layer.cornerRadius = 3.0
        effectView.layer.zPosition = -1
        self.view.addSubview(effectView)
    }
    
    func pushAuthorization(){
        // 許可がされてなければ
        if(!isEnabled()){
            let ud = NSUserDefaults.standardUserDefaults()
            if ud.integerForKey("PLAY_BOY") == 2{
                settingTransitionAlert()
            }
        }
    }
    // 通知許可しているか
    func isEnabled() -> Bool {
        return (UIApplication.sharedApplication().currentUserNotificationSettings()!.types.intersect(UIUserNotificationType.Alert)) != []
    }
    // 設定飛ばせるアラート
    func settingTransitionAlert() {
        let lm = LangManager()
        // Style Alert
        let alert: UIAlertController = UIAlertController(title: lm.getString(20),
            message: lm.getString(21),
            preferredStyle: UIAlertControllerStyle.Alert
        )
        // Cancel 一つだけしか指定できない
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction) -> Void in
        })
        // Default 複数指定可
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                self.openAppSettingPage()
        })
        // AddAction 記述順に反映される
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    // 設定画面に飛ばす(ios8以上限定)
    func openAppSettingPage() -> Void {
        let application = UIApplication.sharedApplication()
        let osVersion = UIDevice.currentDevice().systemVersion
        if osVersion < "8.0" {
            // not supported
        }else{
            let url = NSURL(string:UIApplicationOpenSettingsURLString)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    ////////////////////////////////////////////////
    ////~~~~TURU~~~~///////////////////////////////
    ////////////////////////////////////////////////
    /** 負なら正へ変換 */
    func numberConversion(value:Double) -> Double{
        if(value < 0){
            return value * (-1)
        }
        return value
    }
    //x時x分x秒を秒に変換
    func secondConverter(hour:Int, minute:Int, second:Int) -> Int{
        return (hour*3600) + (minute*60) + second
    }
    func timeConverter(time: Int) -> (Int,Int,Int){
        let second = time%60;
        let minute = (time/60)%60;
        var hour = (time/60/60);
        if hour >= 24 {
            hour -= 24
        }
        return (hour, minute, second)
    }
    func timeSave(){
        let time = timeConverter(ud.integerForKey("PLANSECOND"))
        ud.setInteger(time.0, forKey: "SET_HOUR")
        ud.synchronize()
        ud.setInteger(time.1, forKey: "SET_MINUTE")
        ud.synchronize()
    }
    //数字を英語に変換
    func englishWordsConverter(wordNum:Int) ->String{
        var word = ""
        switch wordNum{
        case 10:
            word = "a"
            break
        case 11:
            word = "b"
            break
        case 12:
            word = "c"
            break
        case 13:
            word = "d"
            break
        case 14:
            word = "e"
            break
        case 15:
            word = "f"
            break
        case 16:
            word = "g"
            break
        case 17:
            word = "h"
            break
        case 18:
            word = "i"
            break
        case 19:
            word = "j"
            break
        case 20:
            word = "k"
            break
        case 21:
            word = "l"
            break
        case 22:
            word = "m"
            break
        case 23:
            word = "n"
            break
        case 24:
            word = "o"
            break
        case 25:
            word = "p"
            break
        case 26:
            word = "q"
            break
        case 27:
            word = "r"
            break
        case 28:
            word = "s"
            break
        case 29:
            word = "t"
            break
        case 30:
            word = "u"
            break
        case 31:
            word = "v"
            break
        case 32:
            word = "w"
            break
        case 33:
            word = "x"
            break
        case 34:
            word = "y"
            break
        case 35:
            word = "z"
            break
        default:
            word = "x"
            break
        }
        
        return word
    }
    
    //アラート出力
    func openAlert(titleStr:String, messageStr:String, okStr:String){
        let alert:UIAlertController = UIAlertController(title:titleStr,
            message: messageStr,
            preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: okStr,
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
//                let textFields:Array<UITextField>? =  alert.textFields
//                if(okStr == "No thank you"){
                    self.ai.showAds() //広告表示
//                }
        })
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func firstContactCheck(){
        let fc = FirstClass()
        fc.setDefault()
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.integerForKey("PLAY_BOY") == 0 {
            ud.setInteger(1, forKey: "PLAY_BOY")
            ud.synchronize()
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "sceneChange", userInfo: nil, repeats: false)
        }
    }
    
    func sceneChange(){
        ud.setBool(bgFlag, forKey: "bgm")
        ud.synchronize()
        let mySecondViewController: UIViewController = UiPageController()
        mySecondViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(mySecondViewController, animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////
    ////~~~~MUSIC~~~~///////////////////////////////
    ////////////////////////////////////////////////
    
    func musicStart(){
        bgFlag = true
        ud.setBool(bgFlag, forKey: "bgm")
        ud.synchronize()
        AVAudioPlayerUtil.play();//再生
        //バイブも鳴らす
        vibTimer = NSTimer.scheduledTimerWithTimeInterval(vibInterval, target: self, selector: "vibUpdate", userInfo: nil, repeats: true)
        objectMove()
        self.ud.setInteger(5, forKey: "TUTORIALLIFE")
        self.ud.synchronize()
    }
    
    func musicStop(){
        if self.bgFlag {
            self.bgFlag = false
            if ud.boolForKey("DAYLY_FLAG") {
                updateSettingTimeDifference() // 設定時間後の時間を更新する
                self.pushNotification()
            } else {
                self.onOffFlag = false
            }
            ud.setBool(self.bgFlag, forKey: "bgm")
            ud.synchronize()
            ud.setBool(self.onOffFlag, forKey: "ONOFF")
            ud.synchronize()
            AVAudioPlayerUtil.playMusicVolumeSetting(1.0)
            AVAudioPlayerUtil.stop()
            dispatch_async(dispatch_get_main_queue(), {
                // 処理が終わった後UIスレッドでやりたいことはここ
                self.alarmSwitch.on = self.onOffFlag
                self.noMusicInit()
            })
        }
    }
    //音楽が止まった時の初期化処理
    func noMusicInit(){
        self.ud.setInteger(4, forKey: "TUTORIALLIFE") //4はストップ
        self.ud.synchronize()
        self.lifePoints = self.ud.integerForKey("LIFEFINAL")
        self.ud.setInteger(self.lifePoints, forKey: "LIFE")
        self.ud.synchronize()
        self.ud.setBool(false, forKey: "HAJIMEIPPO_STILL") //1歩目か初期化
        self.ud.synchronize()
        pointLabel.text = "\(lifePoints)"
        if !onOffFlag {
            NotificationUtil.pushDelete()
        }
        objectMove() //オブジェクト移動
    }
    func vibUpdate(){
        if(bgFlag == true){
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    //割り込み対策
    func audioSessionInterrupted(notification: NSNotification) {
        if let userInfos = notification.userInfo {
            if let type: AnyObject = userInfos["AVAudioSessionInterruptionTypeKey"] {
                if type is NSNumber {
                    if type.unsignedLongValue == AVAudioSessionInterruptionType.Began.rawValue{
//                        print("割り込みきた")
                        if (bgFlag == true && AVAudioPlayerUtil.audioPlayer[0].playing) {
                            //AVAudioPlayerUtil.stop()
                        }
                    }
                    if type.unsignedLongValue == AVAudioSessionInterruptionType.Ended.rawValue{
//                        print("割り込み終わっ・", terminator: "")
                        if (bgFlag == true  && AVAudioPlayerUtil.audioPlayer[0].playing == false) {
                            // 現在再生していないなら再生
//                            print("・・・", terminator: "")
                            AVAudioPlayerUtil.play() //再生
                        }
//                        print("た")
                    }
                }
            }
        }
    }
    //イヤホン挿したり？
    func audioSessionRouteChange(notification: NSNotification) {
        for port in session.currentRoute.outputs {
            if port.portType == AVAudioSessionPortBuiltInSpeaker {
                //内臓スピーカが選ばれている時の処理
//                print("スピーカ")
            }else if port.portType == AVAudioSessionPortHeadphones {
                do {
                    //ヘッドホンが選ばれている時の処理
                    //                println("ヘッドホン")
                    try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                } catch _ {
                }
                do {
                    try session.setActive(true)
                } catch _ {
                }
                do {
                    try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
                } catch _ {
                }
            }
//            for channel in port.channels as! [AVAudioSessionChannelDescription] {
                //左右チャンネルなどの情報が欲しいとき、以下を検討
                //println(channel.channelName)
                //println(channel.channelNumber)
                //println(channel.owningPortUID)
                //println(channel.channelName)
//            }
        }
    }
    
    func getInstanceVolumeButtonNotification(notification: NSNotification) {
        //        var aSession = AVAudioSession()
        //        var volume = aSession.outputVolume
        //        println("音量改變：\(volume)")
        volumeChange.systemVolumeChange(0.3) //システム音変更 //本来は0.3
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        player.stop()
        // 再生終了を通知
        let noti = NSNotification(name: "stop", object: self)
        NSNotificationCenter.defaultCenter().postNotification(noti)
    }
    
    func mannerLabelMoveReturn(){
        let lm = LangManager()
        //        if(mannerCautionTimer != nil){
        //            mannerCautionTimer.invalidate()
        //            mannerCautionTimer = nil
        UIView.animateWithDuration(1.0, animations: {() -> Void in
            self.mannerModeLabel.center = CGPoint(x: -self.mannerModeLabel.bounds.width,y: self.winSize.height/2 + 40)
            }, completion: {(Bool) -> Void in
                self.mannerModeLabel.text = lm.getString(11)
        })
        //        }
    }
    
    //タップしたとき枠が波紋のように広がる
    func anyTapGesture(sender: UITapGestureRecognizer){
        if(bgFlag == true){
            let tmpX:CGFloat = sender.view!.frame.origin.x
            let tmpY:CGFloat = sender.view!.frame.origin.y
            let tmpW:CGFloat = sender.view!.frame.width
            let tmpH:CGFloat = sender.view!.frame.height
            
            let clickActionV:UIView = UIView()
            clickActionV.frame = CGRectMake(tmpX, tmpY, tmpW, tmpH)
            clickActionV.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).CGColor
            clickActionV.layer.borderWidth = winSize.width * 0.03
            clickActionV.layer.zPosition = 5
            self.view.addSubview(clickActionV)
            UIView.animateWithDuration(0.2,
                delay: 0.1,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () in
                    clickActionV.transform = CGAffineTransformMakeScale(1.6, 1.1)
                    clickActionV.alpha = 0
                }, completion: { (Bool) in
                    clickActionV.removeFromSuperview()
            })
        }
    }
    
    /**
     スプラッシュ画面を使ってアニメーションする
     */
    func splashAnimation() {
        let xibView:UIView = UINib(nibName: "LaunchScreen", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! UIView
        xibView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        xibView.layer.zPosition = 4
        self.view.addSubview(xibView)
        
        UIView.transitionWithView(
            xibView, // 対象のビュー
            duration: 2.0,  // アニメーションの時間
            options: UIViewAnimationOptions.CurveEaseOut, // アニメーション変化オプション
            animations: {() -> Void  in
                xibView.alpha = 0
            },
            completion: {(finished: Bool) -> Void in
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //////////////////////////////////////
    /////////// getter,setter ////////////
    //////////////////////////////////////
    
    //時間セットラベル変更
    func setClockLabel(h:Int, m:Int){
        clockLabel.text = "\(h):\(m)"  /**たまにここで止まる*/
        if(m<10){
            clockLabel.text = "\(h):0\(m)"
        }
    }
}