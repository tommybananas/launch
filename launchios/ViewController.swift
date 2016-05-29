//
//  ViewController.swift
//  launchios
//
//  Created by Tom Juszczyk on 5/29/16.
//  Copyright © 2016 Tom Juszczyk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

var ref: FIRDatabaseReference!
var messages: [FIRDataSnapshot]! = []
private var _refHandle: FIRDatabaseHandle!

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = ref.child("path").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            messages.append(snapshot)
            let data = snapshot.value as! NSDictionary
            let lat = data["lat"] as! NSString
            let long = data["long"] as! NSString
            let speed = data["speed"] as! NSString
            let traveled = data["traveled"] as! NSString
            let alt = data["alt"] as! NSString
            let date = data["date"] as! NSString
            
            
            var ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue)
            ann.title = "\(alt) ft, \(speed) mph, \(traveled) miles \(date.componentsSeparatedByString(" ")[0])"
            self.mapView.addAnnotation(ann)
            
            self.textView.text = "Alt: \(alt) ft, Speed: \(speed) mph, tot: \(traveled) miles   \(date.componentsSeparatedByString(" ")[0])\n\(self.textView.text)"
            
            print(messages)
            print("\(lat), \(long)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

