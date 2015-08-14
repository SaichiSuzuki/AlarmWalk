//
//  AdmobInterstitial.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/08.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdmobInterstitial: UIResponder{
    //view宣言
    var view: UIViewController!
    //インタースティシャル広告準備
    var interstitial:GADInterstitial!
    
    /**コンストラクタ*/
    init(view: UIViewController){
        super.init()
        self.view = view //viewを取得
        var viewController = view as! EditViewController //ダウンキャスト
        self.interstitial = viewController.interstitialData //interstitial取得
        admobInterstitialReady() //広告使用準備
    }
    
    //admobインタースティシャル準備
    func admobInterstitialReady(){
        //本番用
        interstitial.adUnitID = "ca-app-pub-1645837363749700/5447856877"
        interstitial.loadRequest(GADRequest())
        //テスト用
        //var request = GADRequest()
        //request.testDevices = ["9e51e86223f362580ae947fffea1b3e8"]
        //interstitial.loadRequest(request)
    }
    
    /**インタースティシャル広告表示*/
    func showAds(){
        interstitial.presentFromRootViewController(view) //インタースティシャル広告表示
    }
    /**x秒後インタースティシャル広告表示
    * @param time x秒後広告を表示する*/
    func showAds(time: NSTimeInterval){
        let interstitialTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "showAds", userInfo: nil, repeats: false)
    }
}