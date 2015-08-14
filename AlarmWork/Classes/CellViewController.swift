//
//  cellViewController.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/11.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

class CellViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Tableで使用する配列を設定する
    private var myItems: [String] = ["You_wanna_fight","Electron","Yukai","Labo","Random"]
    private var myTableView: UITableView!
    
    //試聴中かどうかフラグ
    var audienceFlag = false
    //試聴用ボタン
    var audienceButton: UIButton!
    //音楽なってるかチェックタイマー
    var isMusicCheckTimer: NSTimer!
    //再生ボタン
    //    let playBackCIImage = CIImage(image: UIImage(named: "playBack.png"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCell()
        isMusicCheckTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "isMusicCheck", userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navCon?.setNavigationBarHidden(false, animated: false)
        appDelegate.navCon?.navigationBar.tintColor = UIColor.darkGrayColor() //戻る文字色変更
        let lm = LangManager()
        for (index,n) in enumerate(lm.getMusicName()){
            myItems[index] = n
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**セル作成*/
    func makeCell(){
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceの設定をする.
        myTableView.dataSource = self
        // Delegateを設定する.
        myTableView.delegate = self
        //        myTableView.layer.position = CGPoint(x: winSize.width*(3/2),y: winSize.height/2);
        myTableView.backgroundColor = UIColor.hexStr("34495e", alpha: 1.0)
        // Viewに追加する.
        self.view.addSubview(myTableView)
    }
    
    
    /*
    Cellが選択された際に呼び出されるデリゲートメソッド.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        for (var i=0; i<tableView.numberOfSections(); ++i){
        //            for (var j=0; j<tableView.numberOfRowsInSection(i); ++j){
        //                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))
        //                c!.backgroundColor = UIColor.hexStr("34495e", alpha: 0.7)
        //            }
        //        }
        allCellAction(tableView,type: "color")
        musicSave(indexPath.row)
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(indexPath.row, forKey: "INDEX_PATH")
        ud.synchronize()
        
        //こっちにいても鳴るかどうか？多分なりそう
        
    }
    
    /**全てのセルに対する処理*/
    func allCellAction(tableView: UITableView,type:String){
        for (var i=0; i<tableView.numberOfSections(); ++i){
            for (var j=0; j<tableView.numberOfRowsInSection(i); ++j){
                var c = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))
                switch type{
                case "color":
                    colorInit(c!)
                    break
                case "button":
                    buttonInit(c!.accessoryView as! UIButton)
                    break
                default:
                    break
                }
            }
        }
    }
    
    func colorInit(cell: UITableViewCell){
        cell.backgroundColor = UIColor.hexStr("34495e", alpha: 0.7)
    }
    func buttonInit(sender: UIButton){
        if(audienceFlag == true){
            AVAudioPlayerUtil.stopTest();//再生
        }
        sender.setTitle("♪", forState: .Normal)
    }
    
    /**Cellの選択がはずれたときに呼び出される*/
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // 選択されたセルを取得
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.backgroundColor = UIColor.hexStr("34495e", alpha: 0.7)
    }
    /*
    Cellの総数を返すデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    /*
    Cellに値を設定するデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(myItems[indexPath.row])"
        cell.backgroundColor = UIColor.hexStr("34495e", alpha: 0.7)
        
        // Cell内のラベルの色変更
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        //試聴ボタン追加
        audienceButton = UIButton(frame: CGRectMake(0, 0, 50, 45))
//        audienceButton.layer.backgroundColor = UIColor.redColor().CGColor!
        audienceButton.setTitle("♪", forState: .Normal)
        //        audienceButton.setImage(UIImage(CIImage: playBackCIImage), forState: .Normal)
        audienceButton.addTarget(self, action: "musicAudition:", forControlEvents:.TouchUpInside)
        audienceButton.tag = indexPath.row
        cell.accessoryView = audienceButton
        
        // 選択された時の背景色
        var cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.hexStr("3499e9e", alpha: 0.7)
        cell.selectedBackgroundView = cellSelectedBgView
        
        let ud = NSUserDefaults.standardUserDefaults()
        var ip = ud.integerForKey("INDEX_PATH")
        if(indexPath.row == ip){
            cell.backgroundColor = UIColor.hexStr("3499e9e", alpha: 1.0)
        }
        
        //        tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        return cell
    }
    
    /**音楽なっていればタイトルへ遷移*/
    func isMusicCheck(){
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.boolForKey("bgm") == true){
            if isMusicCheckTimer.valid == true {
                isMusicCheckTimer.invalidate()
            }
            let evc = EditViewController()
            self.navigationController?.pushViewController(evc, animated: false)
        }
    }
    
    func musicAudition(sender: UIButton){
        let ud = NSUserDefaults.standardUserDefaults()
        var temp = ud.stringForKey("MUSIC_NAME")
        musicSave(sender.tag)
        /**今の所アラーム中にやってはいけない設定*/
        /**マナー中ならならないようにしたい*/
        if(sender.titleLabel?.text == "♪" && audienceFlag == true){
            allCellAction(myTableView,type: "button")
        }
        if(sender.titleLabel?.text == "♪"){
            audienceFlag = true
            AVAudioPlayerUtil.testPlay();//再生
            sender.setTitle("||", forState: .Normal)
        }
        else{
            audienceFlag = false
            AVAudioPlayerUtil.stopTest();//停止
            sender.setTitle("♪", forState: .Normal)
        }
        ud.setObject(temp, forKey: "MUSIC_NAME")
        ud.synchronize()
    }
    
    //音楽選択ボタン
//    func musicSelectAction(cellNum:Int){
//        musicSave(cellNum)
//    }
    func musicSave(num:Int){
        var bgName = "nil"
        var n = num
        while(bgName == "nil"){
            bgName = selectBGM(n)
            n = Int(arc4random() % UInt32(myItems.count))
        }
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(bgName, forKey: "MUSIC_NAME")
        ud.synchronize()
    }
    func selectBGM(num:Int) -> String{
        var bgName = ""
        switch num{
        case 0:
        bgName = "You_wanna_fightC"
            break
        case 1:
        bgName = "Electron"
            break
        case 2:
        bgName = "Yukai"
            break
        case 3:
        bgName = "Labo"
            break
        default:
            bgName = "nil"
            break
        }
        return bgName
    }
    
    
}

