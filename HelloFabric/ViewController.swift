//
//  ViewController.swift
//  HelloFabric
//
//  Created by toyboy17 on 2016/7/4.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit
import Crashlytics
import DigitsKit
//同時使用Answer與Crashlytics時，不需import Answer，否則會報錯！！！

import mopub_ios_sdk//與文件不同，新增加


class ViewController: UIViewController, MPAdViewDelegate {
    
    // MoPub實作 TODO: Replace this test id with your personal ad unit id
    var adView: MPAdView = MPAdView(adUnitId: "0fd404de447942edb7610228cb412614", size: MOPUB_BANNER_SIZE)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //以下為Crashlytics實作
        let btnCrashly = UIButton(type: UIButtonType.RoundedRect)
        //範例碼 button改為btnCrashly
        
        btnCrashly.frame = CGRectMake(20, 50, 100, 30)
        //設定按鈕畫面位置(x,y,長,寬)
        btnCrashly.setTitle("CrashEvent", forState: UIControlState.Normal)
        //上排按鈕設定文字為CrashEvent，用程式產生，這是一個測試crash發生的模擬按鈕
        //按下按鈕後，後台偵測數字即會改變，用來確認偵測是否成功
        
        btnCrashly.addTarget(self, action: #selector(self.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnCrashly)
        
        //以下為Answer實作 Add Key Metric 新增一個想偵測的觸發按鈕
        //create a button to represent "an important action" in your app, and log a custom event to track this metric.
        let btnAnswer = UIButton(type: UIButtonType.RoundedRect)
        //範例碼 button改為btnAnswer
        
        btnAnswer.frame = CGRectMake(20, 100, 100, 30)//設定按鈕畫面位置(x,y,長,寬)
        btnAnswer.setTitle("Trigger Key Metric", forState: UIControlState.Normal)
        //Trigger Key Metric"偵測觸發按鈕"用程式產生，這是一個練習用的模擬按鈕
        //按下按鈕後，後台偵測數字即會改變，用來確認偵測是否成功
        
        btnAnswer.addTarget(self, action: #selector(self.anImportantUserAction), forControlEvents: UIControlEvents.TouchUpInside)
        btnAnswer.sizeToFit()
        //btnAnswer.center = self.view.center 原範例碼按鈕位置至中
        view.addSubview(btnAnswer)
        
        //以下為Digits的實作 使用電話號碼登入use my phone number
        let authButton = DGTAuthenticateButton(authenticationCompletion: { (session: DGTSession?, error: NSError?) in
            if (session != nil) {
                // TODO: associate the session userID with your user model
                let message = "Phone number: \(session!.phoneNumber)"
                let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: .None))
                self.presentViewController(alertController, animated: true, completion: .None)
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        })
        authButton.digitsAppearance = self.makeTheme()//Digis 新增程式碼
        authButton.frame = CGRectMake(20, 150, 200, 30)//設定按鈕畫面位置(x,y,長,寬)

        //authButton.center = self.view.center 原範例碼按鈕位置至中
        self.view.addSubview(authButton)
        
        //以下為Digits的實作 Upload an Address Book and lookup friends自動更新通訊錄朋友
        let authenticateButton = DGTAuthenticateButton { session, error in
            if session != nil {
        // Delay showing the contacts uploader while the Digits screen animates off-screen
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                    self.uploadDigitsContacts(session)
                }
            }
        }
        authenticateButton.frame = CGRectMake(20, 200, 200, 30)//設定按鈕畫面位置(x,y,長,寬)
        //authenticateButton.center = self.view.center 原範例碼按鈕位置至中
        self.view.addSubview(authenticateButton)
        
        //以下為MoPub實作
        self.adView.delegate = self
        
        // Positions the ad at the bottom, with the correct size
        self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                       MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        
        // Loads the ad over the network
        self.adView.loadAd()



    }//我是viewDidLoad的結束大括號
    
    //crashly IBAction按鈕  不可放在viewdidload中 模擬crash事件按鈕
    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    //模擬器按鈕報錯Thread 1:EXC_BAD_INSTRUCTION(code=EXC_i386_INVOP, subcode=0x0)
    }
    
    //Answer呼叫的method  不可放在viewdidload中 偵測按鈕點擊行為
    func anImportantUserAction() {
        
    // TODO: Move this method and customize the name and parameters to track your key metrics
    // Use your own string attributes to track common values over time
    // Use your own number attributes to track median value over time
        Answers.logCustomEventWithName("Video Played", customAttributes: ["Category":"Comedy", "Length":350])
        //此範例為偵測影片點擊行為，產生兩種customAttributes Event log，將紀錄傳回後台
        //目錄：喜劇，session長度：350s
        
    }
    
    //Digi呼叫的method  不可放在viewdidload中 更改登入介面內文字型、標籤字型、強調色、背景色
    func makeTheme() -> DGTAppearance {
        let theme = DGTAppearance();
        theme.bodyFont = UIFont(name: "Noteworthy-Light", size: 16);
        theme.labelFont = UIFont(name: "Noteworthy-Bold", size: 17);
        theme.accentColor = UIColor(red: (255.0/255.0), green: (172/255.0), blue: (238/255.0), alpha: 1);
        theme.backgroundColor = UIColor(red: (240.0/255.0), green: (255/255.0), blue: (250/255.0), alpha: 1);
        // TODO: set a UIImage as a logo with theme.logoImage
        return theme;
    }
    
    //Digi呼叫的method  不可放在viewdidload中 通訊錄朋友自動更新
    private func uploadDigitsContacts(session: DGTSession) {
        let digitsContacts = DGTContacts(userSession: session)
        digitsContacts.startContactsUploadWithCompletion { result, error in
            if result != nil {
                // The result object tells you how many of the contacts were uploaded.
                print("Total contacts: \(result.totalContacts), uploaded successfully: \(result.numberOfUploadedContacts)")
            }
            self.findDigitsFriends(session)
        }
    }
    
    //Digi呼叫的method  不可放在viewdidload中 尋找朋友
    private func findDigitsFriends(session: DGTSession) {
        let digitsContacts = DGTContacts(userSession: session)
        // looking up friends happens in batches. Pass nil as cursor to get the first batch.
        digitsContacts.lookupContactMatchesWithCursor(nil) { (matches, nextCursor, error) -> Void in
            // If nextCursor is not nil, you can continue to call lookupContactMatchesWithCursor: to retrieve even more friends.
            // Matches contain instances of DGTUser. Use DGTUser's userId to lookup users in your own database.
            print("Friends:")
            
//            for digitsUser in matches {
//                print("Digits ID: \(digitsUser.userID)")
//            }
            //註解掉的範例檔案，bug未解
            
            
            // Show the alert on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                let message = "\(matches.count) friends found!"
                let alertController = UIAlertController(title: "Lookup complete", message: message, preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "OK", style: .Cancel, handler:nil)
                alertController.addAction(cancel)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewControllerForPresentingModalView() -> UIViewController! {
        return self//??
    }
    

}//我是viewController的結束大括號

