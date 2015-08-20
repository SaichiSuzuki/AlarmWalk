//
//  ViewController.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/18.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit
import StoreKit //←インポートしてください

class PurchaseController: UIResponder, SORPurchaseManagerDelegate {
    private var uiv:UIViewController = UIViewController()
    private var myActivityIndicator: UIActivityIndicatorView! //インジゲーター
    private var darkBackBtn: UIButton!
    
    /**コンストラクタ*/
    init(v:UIViewController){
        self.uiv = v
    }
    /**課金処理*/
    func purchase(){
        self.startPurchase("SELECT_MUSIC")
    }
    
    /**課金開始*/
    func startPurchase(productIdentifier : String) {
        createUI()
        //デリゲード設定
        SORPurchaseManager.sharedManager().delegate = self
        //プロダクト情報を取得
        SORProductManager.productsWithProductIdentifiers([productIdentifier], completion: { (products, error) -> Void in
            if products.count > 0 {
                //課金処理開始
                SORPurchaseManager.sharedManager().startWithProduct(products[0])
            }
        })
    }
    func createUI(){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navCon?.setNavigationBarHidden(true, animated: false)
        //背景ボタン作成する
        darkBackBtn = UIButton(frame: CGRectMake(0, 0, uiv.view.bounds.width, uiv.view.bounds.height))
        darkBackBtn.layer.backgroundColor = UIColor.hexStr("3c3c3c", alpha: 0.8).CGColor!
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        myActivityIndicator.center = self.uiv.view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        myActivityIndicator.startAnimating()
        myActivityIndicator.hidden = false
        self.uiv.view.addSubview(darkBackBtn)
        self.uiv.view.addSubview(myActivityIndicator)
    }
    
    func deleteUI(){
        myActivityIndicator.hidden = true
        darkBackBtn.removeFromSuperview()
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navCon?.setNavigationBarHidden(false, animated: false)
    }
    
    /// リストア開始
    func startRestore() {
        //デリゲード設定
        SORPurchaseManager.sharedManager().delegate = self
        //リストア開始
        SORPurchaseManager.sharedManager().startRestore()
    }
    
    
    // MARK: - SORPurchaseManager Delegate
    func purchaseManager(purchaseManager: SORPurchaseManager!, didFinishPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((complete: Bool) -> Void)!) {
        //課金終了時に呼び出される
        /*
        コンテンツ解放処理
        */
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "PURCHASE_MUSIC")
        ud.synchronize()
        deleteUI()
        let cvc:CellViewController = self.uiv as! CellViewController
        cvc.getPurchaseBtn().removeFromSuperview() //課金ボタン削除
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(complete: true)
    }
    
    func purchaseManager(purchaseManager: SORPurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((complete: Bool) -> Void)!) {
        //課金終了時に呼び出される(startPurchaseで指定したプロダクトID以外のものが課金された時。)
        /*
        コンテンツ解放処理
        */
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(complete: true)
    }
    
    func purchaseManager(purchaseManager: SORPurchaseManager!, didFailWithError error: NSError!) {
        //課金失敗時に呼び出される
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Please try again"
        alert.addButtonWithTitle("OK")
        alert.show()
        deleteUI()
    }
    
    func purchaseManagerDidFinishRestore(purchaseManager: SORPurchaseManager!) {
        //リストア終了時に呼び出される(個々のトランザクションは”課金終了”で処理)
        /*
        インジケータなどを表示していたら非表示に
        */
        deleteUI()
    }
    
    func purchaseManagerDidDeferred(purchaseManager: SORPurchaseManager!) {
        //承認待ち状態時に呼び出される(ファミリー共有)
        /*
        インジケータなどを表示していたら非表示に
        */
        deleteUI()
    }
    
}