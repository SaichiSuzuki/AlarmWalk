//
//  RandMusic.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/14.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//


class RandMusic{
    init(){
    }
    func getRandMusic() -> String{
        var bgName = ""
        var rand = arc4random() % 4
        switch Int(rand){
        case 0:
            bgName = "You_wanna_fightC"
            break
        case 1:
            bgName = "Electron"
            break
        case 2:
            bgName = "Yukai"
            break
        default:
            bgName = "Labo"
            break
        }
        return bgName
    }

}
