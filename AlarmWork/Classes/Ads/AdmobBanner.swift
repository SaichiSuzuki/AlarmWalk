//
//  AdmobBanner.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/08.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

class AdmobBanner: UIResponder{
    //view宣言
    var view: UIViewController!
    //バナー広告準備
    var bannerView: GADBannerView = GADBannerView()
    
    init(view: UIViewController){
        super.init()
        self.view = view //viewを取得
    }
    
    func adbannerOpen(){
        bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        bannerView.adUnitID = "ca-app-pub-1645837363749700/1318708476" // ユニットID
        bannerView.rootViewController = view
        let viewController = view as! UiPageController //ダウンキャスト
        bannerView.layer.position = CGPoint(x: viewController.winSizeData.width/2, y: viewController.winSizeData.height - 25)
        viewController.view.addSubview(bannerView)
        //        var request = GADRequest()
        //        request.testDevices = ["9e51e86223f362580ae947fffea1b3e8"]
        //        bannerView.loadRequest(request) //テスト用
        bannerView.loadRequest(GADRequest()) //本番用
    }
    
}