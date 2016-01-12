//
//  ZebraController.swift
//  AlarmWork
//
//  Created by saichi on 2016/01/11.
//  Copyright © 2016年 SaichiSuzuki. All rights reserved.
//

import UIKit

class ZebraController: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named:"simaumar04.png")
        self.userInteractionEnabled = true // tap許可を与える
        let tapBtn = UITapGestureRecognizer(target: self, action: "tapAction")
        self.addGestureRecognizer(tapBtn)
    }
    // 横移動
    func moveHorizontal() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.layer.position = CGPoint(x: self.layer.position.x + 270, y: self.layer.position.y)
        })
    }
    func animationStart() {
        moveHorizontal()
    }
    func tapAction() {
        AVAudioPlayerUtil.playSE("powerup05")
        jumpAnimation()
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "moveLink", userInfo: nil, repeats: false)
    }
    func moveLink() {
        let url = NSURL(string: "https://itunes.apple.com/us/app/ultrazebra/id853473067?l=ja&ls=1&mt=8")
        UIApplication.sharedApplication().openURL(url!)
    }
    func jumpAnimation() {
        UIView.transitionWithView(
            self, // 対象のビュー
            duration: 0.3,  // アニメーションの時間
            options: UIViewAnimationOptions.CurveEaseOut, // アニメーション変化オプション
            animations: {() -> Void  in
                // アニメーションする処理
                self.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y - 50)
            },
            completion: {(finished: Bool) -> Void in
                // アニメーション終了後の処理
                UIView.transitionWithView(
                    self, // 対象のビュー
                    duration: 0.2,  // アニメーションの時間
                    options: UIViewAnimationOptions.CurveEaseIn, // アニメーション変化オプション
                    animations: {() -> Void  in
                        // アニメーションする処理
                        self.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y + 50)
                    },
                    completion: {(finished: Bool) -> Void in
                        // アニメーション終了後の処理
                })
        })
    }
}
