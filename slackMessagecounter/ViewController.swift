//
//  ViewController.swift
//  slackMessagecounter
//
//  Created by Andrew Harris on 4/25/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//


import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var dateDisplay: NSTextField!
    @IBOutlet weak var todayCount: NSTextField!
    @IBOutlet weak var weekCount: NSTextField!


    @IBAction func someButton(sender: AnyObject) {
        dateDisplay.stringValue = setTime()
        
        querySlack("2016-04-26")
    }
    
    
//TODO: consider expanding this to return just the date or just the time based on a param
    func setTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func querySlack(dateAfter: String) {
//TODO: make https://slack.com/api/search.messages?token=xoxp-3153534091-37521654836-37628781536-40cdbbe841&query=from:me after:2016-04-26&pretty=1 easier to adjust - specifically the date

        //TODO: Move somewhere safe
        let token = "xoxp-3153534091-37521654836-37628781536-40cdbbe841"
        let endpoint = "https://slack.com/api/search.messages?token=" + token + "&pretty=1&query=from:me%20after:" + dateAfter
        
        let request = NSMutableURLRequest(URL: NSURL(string: endpoint)!)
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
                //TODO: Manipulate this somehow
            }
        }
        
        
    }
    
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
    
}