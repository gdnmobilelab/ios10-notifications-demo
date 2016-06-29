//
//  ViewController.swift
//  notification-demo
//
//  Created by Alastair Coote on 6/28/16.
//  Copyright © 2016 Alastair Coote. All rights reserved.
//

import UIKit
import UserNotifications;


struct ButtonAndFunc {
    var title:String
    var tapFunc:Selector
}

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let topMargin = 40
    
    func showNotificationAndSuspend(content:UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notify-test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request);
        UIControl().sendAction(Selector("suspend"), to: UIApplication.shared(), for: nil)

    }
    
    
    
//    let showImageNotification =
//        #selector(ViewController.imageNotification(_:))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addButtons(buttons: [
            ButtonAndFunc(title: "Image notification", tapFunc: #selector(ViewController.imageNotification(sender:))),
            ButtonAndFunc(title: "Video notification", tapFunc: #selector(ViewController.videoNotification(sender:))),
            ButtonAndFunc(title: "Updating notification", tapFunc: #selector(ViewController.selfUpdatingNotification(sender:)))
        ])
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization([.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
         UNUserNotificationCenter.current().delegate = self
    }
    
    func addButtons(buttons:[ButtonAndFunc]) {
        var top = self.topMargin
        let buttonHeight = 50
        let buttonWidth = Int(UIScreen.main().bounds.width) - 20
        
        for button in buttons {
            let uiButton = UIButton(type: UIButtonType.roundedRect)
            uiButton.frame = CGRect(x: 10,y: top,width: buttonWidth,height: buttonHeight)
            
            uiButton.setTitle(button.title, for: [])
            self.view.addSubview(uiButton)
            
            top += buttonHeight + 10
            
            uiButton.addTarget(self, action: button.tapFunc, for: UIControlEvents.touchUpInside)
        }
        
    }
    
    func selfUpdatingNotification(sender: UIButton) throws {
        let seconds = [1,2,3,4,5]
        
        for second in seconds {
            
            let content = UNMutableNotificationContent()
            content.title = "This is an updating notification"
            content.body = "This is update #" + String(second);
            content.categoryIdentifier = "gdmobilelab.notification-demo.selfUpdate"
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second), repeats: false)
            
            let request = UNNotificationRequest(identifier: "notify-test-" + String(second), content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request);
        }
        UIControl().sendAction(Selector("suspend"), to: UIApplication.shared(), for: nil)

    }
    
    func imageNotification(sender: UIButton) throws {
        let content = UNMutableNotificationContent()
        content.title = "This is an image notification"
        content.body = "This is test copy for a notification"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "gdmobilelab.notification-demo.localNotification"
        
        let imagePath = Bundle.main().pathForResource("corbyn", ofType: "jpg")
        
        let imageURL = URL(fileURLWithPath: imagePath!)
        let attach = try UNNotificationAttachment(identifier: "image-test", url: imageURL, options: [:])
        content.attachments.append(attach);
        
        self.showNotificationAndSuspend(content: content);
    }
    
    func videoNotification(sender: UIButton) throws {
        let content = UNMutableNotificationContent()
        content.title = "This is a video notification"
        content.body = "This is test copy for a notification"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "gdmobilelab.notification-demo.localNotification"
        
        let videoPath = Bundle.main().pathForResource("video-test", ofType: "mp4")
        
        let videoURL = URL(fileURLWithPath: videoPath!)
        let attach = try UNNotificationAttachment(identifier: "video-test", url: videoURL, options: [:])
        content.attachments.append(attach);
        
        self.showNotificationAndSuspend(content: content);
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        NSLog("Got to here")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        NSLog("Open?")
        // Delivers a notification to an app running in the foreground.
    }
}

