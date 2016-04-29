//
//  ViewController.swift
//  slackMessagecounter
//
//  Created by Andrew Harris on 4/25/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//


import Cocoa
import SwiftyJSON

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


    @IBAction func runButton(sender: AnyObject) {
        dateDisplay.stringValue = getCurrentTime()

        let queryDateToday = getQueryDate(1) // query today
        let queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday)
      
        
        
        //Tests
        print("Date param: " + queryDateToday)
        print("URL param: " + String(queryURLToday))
        
    }
    
    
    //TODO: consider expanding this to return just the date or just the time based on a param
    func getCurrentTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    
    //  Returns the date string for the API call
    func getQueryDate(daysBehind: Int) -> String {
        let userCalendar = NSCalendar.currentCalendar()
        let periodComponents = NSDateComponents()
            periodComponents.day = -daysBehind
        
        let searchDate = userCalendar.dateByAddingComponents(periodComponents, toDate: NSDate(), options: [])!
        let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateReturn = dateFormatter.stringFromDate(searchDate)
        
        return dateReturn
    }
    
    func createURL(dateAfter: String) -> NSURL {
        //TODO: Move somewhere safe
        let token = "xoxp-3153534091-37521654836-37628781536-40cdbbe841"
        let endpoint = "https://slack.com/api/search.messages?token=" + token + "&query=from:me%20after:" + dateAfter + "&pretty=1"
        let request = NSURL(string: endpoint)!
        
        return request
    }
    
    func getMessageCount(data: String) -> String {
        var messageCount = ""
        if let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            let totalMessagesSent = jsonData["messages","pagination","total_count"].stringValue
            
            //print("Total messages sent: " + totalMessagesSent)
            messageCount = totalMessagesSent
        }
        //return totalMessagesSent
        print ("Message count: " + messageCount)
        return messageCount
    }
    
    func data_request(url_to_request: NSURL)
    {
        let url:NSURL = url_to_request
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {
            [weak self] (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            guard let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                print("error")
                return
            }
            
            self?.getMessageCount(dataString as String)
            
            print(dataString)
            
        }
        
        task.resume()
        
    }

    
}