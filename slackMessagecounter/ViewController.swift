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
        var queryDateToday = getQueryDate(1) // query today
        var queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: true)
        
        queryDateToday = getQueryDate(7) // query today
        queryURLToday = createURL(queryDateToday)
        data_request(queryURLToday, isDay: false)
        dateDisplay.stringValue = getCurrentTime()

        //Tests
        print("Date param: " + queryDateToday)
        print("URL param: " + String(queryURLToday))
    }
    
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
        let token = Config.slackApiToken
        
        if token == "" {
            print("You must supply the Slack token in Config.swift to execute query.")
            exit(0)
        }
        
        let endpoint = "https://slack.com/api/search.messages?token=" + token + "&query=from:me%20after:" + dateAfter + "&pretty=1"
        let request = NSURL(string: endpoint)!
        
        return request
    }
    
    func getMessageCount(data: String, isDay: Bool) -> String {
        var messageCount = ""
        let isDayResponse = isDay
        if let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            let totalMessagesSent = jsonData["messages","pagination","total_count"].stringValue
            
            //print("Total messages sent: " + totalMessagesSent)
            messageCount = totalMessagesSent
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if isDayResponse == true {
                self.todayCount.stringValue = messageCount
                print("testing set today count func: " + messageCount)
            }
            else {
                self.weekCount.stringValue = messageCount
                print("testing set week count func: " + messageCount)
            }
        }
        
        return messageCount
    }
    
    //isDay determines if we're updating the "day" or "week" field in the UI
    func data_request(url_to_request: NSURL, isDay: Bool)
    {
        let url:NSURL = url_to_request
        let isDayResponse = isDay
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
            
            self?.getMessageCount(dataString as String, isDay: isDayResponse)
            //print(dataString)
        }
        task.resume()
    }

}