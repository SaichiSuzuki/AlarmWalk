//
//  MyScrollView.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/11.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

/**ScrollViewを使用してもtouch検出ができるようにしたクラス*/
class MyScrollView: UIScrollView {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        superview?.touchesBegan(touches, withEvent: event)
    }
    
}