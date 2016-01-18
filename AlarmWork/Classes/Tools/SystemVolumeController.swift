//
//  SystemVolumeController.swift
//  AlarmWork
//
//  Created by 鈴木才智 on 2015/02/23.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class SystemVolumeController {
    
    //システム音変更
    func systemVolumeChange(setVolume:Float){
        let aSession = AVAudioSession()
        let volume = aSession.outputVolume
        if(volume < setVolume){ //v以下なら強制vに
            let volumeView = MPVolumeView()
            for view in volumeView.subviews {
                if view is UISlider {
                    (view as! UISlider).value = setVolume
                    break;
                }
            }
        }
    }
    //システム音減少
    func systemVolumeDecrease(setVolume:Float){
        let aSession = AVAudioSession()
        let volume = aSession.outputVolume
        if(volume > setVolume){ //v以上なら強制vに
            let volumeView = MPVolumeView()
            for view in volumeView.subviews {
                if view is UISlider {
                    (view as! UISlider).value = setVolume
                    break;
                }
            }
        }
    }
    
}