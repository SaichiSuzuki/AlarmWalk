//
//  musicController.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/03/02.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AudioToolbox

struct AVAudioPlayerUtil {
    
    static var audioPlayer:[AVAudioPlayer] = [AVAudioPlayer(),AVAudioPlayer(),AVAudioPlayer(),AVAudioPlayer()];
    static var sound_data:NSURL = NSURL();
    
    static func setValue(nsurl:NSURL){
        self.sound_data = nsurl;
        self.audioPlayer[0] = AVAudioPlayer(contentsOfURL: self.sound_data, error: nil); //バックグラウンドでも鳴らす
        self.audioPlayer[0].numberOfLoops = -1;
        self.audioPlayer[0].prepareToPlay();
    }
    static func setValueSE(nsurl:NSURL){
        self.sound_data = nsurl;
        self.audioPlayer[1] = AVAudioPlayer(contentsOfURL: self.sound_data, error: nil);
        self.audioPlayer[1].prepareToPlay();
    }
    static func setValueFinish(nsurl:NSURL){
        self.sound_data = nsurl;
        self.audioPlayer[2] = AVAudioPlayer(contentsOfURL: self.sound_data, error: nil);
        self.audioPlayer[2].prepareToPlay();
    }
    static func setValueTest(nsurl:NSURL){
        self.sound_data = nsurl;
        self.audioPlayer[3] = AVAudioPlayer(contentsOfURL: self.sound_data, error: nil);
        self.audioPlayer[3].numberOfLoops = -1;
        self.audioPlayer[3].prepareToPlay();
    }
    static func play(){
        let musicNameStrPlay:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
        AVAudioPlayerUtil.setValue(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicNameStrPlay, ofType: "caf")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[0].play();
        mainSetting();
    }
    static func testPlay(){
        let musicNameStrTestPlay:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
        AVAudioPlayerUtil.setValueTest(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicNameStrTestPlay, ofType: "caf")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[3].play();
    }
    static func mainSetting(){
        let main = EditViewController() //別クラス参照方法
        main.bgFlag = true
        main.myUserDafault.setBool(main.bgFlag, forKey: "bgm")
        main.myUserDafault.synchronize()
    }
    static func playSE(){
        AVAudioPlayerUtil.setValueSE(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("effect_timewarning", ofType: "mp3")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[1].play();
    }
    static func playSEVolumeSetting(v:Float){
        self.audioPlayer[0].volume = v
    }
    static func playFinish(){
        AVAudioPlayerUtil.setValueFinish(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("FinishSE", ofType: "wav")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[2].play();
    }
    static func playTestFinish(){
        AVAudioPlayerUtil.setValueFinish(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("chin", ofType: "mp3")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[2].play();
    }
    static func stop(){
        self.audioPlayer[0].stop();
    }
    static func stopTest(){
        //ストップで準備は書きたくないがストップのが先に呼ばれるためとりあえず書く
        let musicNameStrStopTest:String = NSUserDefaults.standardUserDefaults().stringForKey("MUSIC_NAME")!
        AVAudioPlayerUtil.setValueTest(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicNameStrStopTest, ofType: "caf")!)!);//ファイルセット（再生前事前準備）
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        self.audioPlayer[3].stop();
    }
    static func playMusicVolumeSetting(v:Float){
        self.audioPlayer[0].volume = v
    }
}