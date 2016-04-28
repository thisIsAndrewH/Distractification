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


    @IBAction func runButton(sender: AnyObject) {
        dateDisplay.stringValue = getCurrentTime()

        querySlack(getQueryDate(7)) // query one week ago
        querySlack(getQueryDate(1)) // query today
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
        
        print(dateReturn)
        return dateReturn
    }
    
    func querySlack(dateAfter: String) {
        //TODO: Move somewhere safe
        let token = "xoxp-3153534091-37521654836-37628781536-40cdbbe841"
        let endpoint = "https://slack.com/api/search.messages?token=" + token + "&query=from:me%20after:" + dateAfter + "&pretty=1"
        
        let request = NSMutableURLRequest(URL: NSURL(string: endpoint)!)
        print(request)
       
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
                //TODO: display error if unsucessful
            } else {
                print(data)
                //TODO: create method to handle the data retrieved
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
    
    func getCount(someData: NSData) {
        var names = [String]()
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(someData, options: .AllowFragments)//(data, options: .AllowFragments)
            
            if let blogs = json["blogs"] as? [[String: AnyObject]] {
                for blog in blogs {
                    if let name = blog["name"] as? String {
                        names.append(name)
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        print(names) // ["Bloxus test", "Manila Test"]
    }
    
    
}