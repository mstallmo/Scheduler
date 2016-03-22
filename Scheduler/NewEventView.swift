//
//  NewEventView.swift
//  Scheduler
//
//  Created by Mason Stallmo on 3/21/16.
//  Copyright © 2016 Mason Stallmo. All rights reserved.
//

import UIKit
import EventKitUI

class NewEventView: UIViewController {
    
    @IBOutlet weak var eventLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var eventStore: EKEventStore?
    var eventName: String = "Event"
    var eventDate: NSDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        eventStore = EKEventStore()
        updateAuthorizationStatusToAccessEventStore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAuthorizationStatusToAccessEventStore(){
        let eventAuthorizationStatus: EKAuthorizationStatus = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event);
        
        switch eventAuthorizationStatus {
        case EKAuthorizationStatus.Denied:
            print("Denied")
            // Should pop an alert here
        case EKAuthorizationStatus.Restricted:
            print("Restricted")
            // Should pop an alert here too?
        case EKAuthorizationStatus.Authorized:
            print("Authorized")
        
        case EKAuthorizationStatus.NotDetermined:
            print("Not Determined")
            eventStore?.requestAccessToEntityType(EKEntityType.Event, completion: {
                granted, error in
                if granted {
                    print("Access was granted")
                }
                else {
                    print("Access was denied, or error")
                    if let theError = error {
                        print("Error: \(theError.description)")
                    }
                }
            })
        }

    }
    
    func addEvent() {
        print("added event")
        let event = EKEvent(eventStore: eventStore!)
        event.title = eventName
        event.startDate = eventDate
        event.endDate = NSDate().dateByAddingTimeInterval(24*60*60)
        event.calendar = (self.eventStore?.defaultCalendarForNewEvents)!
        do{
            try self.eventStore?.saveEvent(event, span: EKSpan.ThisEvent , commit: true)
        } catch {
            print("Error saving event")
        }
        
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveButton === sender {
            eventName = eventLabel.text!
            eventDate = datePicker.date
            
            addEvent()
        }
    }
    
}
