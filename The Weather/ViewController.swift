//
//  ViewController.swift
//  The Weather
//
//  Created by Lisa Swanson on 10/5/15.
//  Copyright © 2015 LisaDeeSwanson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var weatherResults: UILabel!
    
    @IBAction func getTheWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityLabel.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
    
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if websiteArray.count > 1 {
                    
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            
                            self.weatherResults.text = weatherSummary
                            self.cityLabel.text = ""
                        })
                    }
                }
                if wasSuccessful == false {
                    
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.weatherResults.text = "Couldn't find the weather for that city. Please try again."
                        self.cityLabel.text = ""

                    })
                }
            }
        }
            
        task.resume()
            
        } else {
            
            self.weatherResults.text = "Couldn't find the weather for that city. Please try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        cityLabel.resignFirstResponder()
        return true
        
    }


}

