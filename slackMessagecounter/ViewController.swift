//
//  ViewController.swift
//  slackMessagecounter
//
//  Created by Andrew Harris on 4/25/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//


//TODO: make https://slack.com/api/search.messages?token=xoxp-3153534091-37521654836-37628781536-40cdbbe841&query=from:me after:2016-04-26&pretty=1 easier to adjust - specifically the date
//TODO: Add a date picker
//TODO: run last 7 days and last 1 day and display both

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
        dateDisplay.stringValue = setTime();
    }
    
   
    
    func setTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    

}