//
//  ViewController.swift
//  Scheduler
//
//  Created by Mason Stallmo on 2/29/16.
//  Copyright © 2016 Mason Stallmo. All rights reserved.
//

import UIKit
import EventKitUI

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var eventStore: EKEventStore?
    var events: [EKEvent]?
    var calendars: [EKCalendar]?

    

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events!.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath)
        
        if events != nil {
        let event = events![indexPath.row]
        
        cell.textLabel?.text = event.title
         
            
        } else {
            cell.textLabel?.text = "No events"
        }
        
        return cell
    }
    
    func updateAuthorizationStatusToAccessEventStore() {
        let eventAuthorizationStatus: EKAuthorizationStatus = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event);
        let reminderAuthorizationStatus: EKAuthorizationStatus = EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder);
        
        switch eventAuthorizationStatus {
        case EKAuthorizationStatus.Denied:
            print("Denied")
            // Should pop an alert here
        case EKAuthorizationStatus.Restricted:
            print("Restricted")
            // Should pop an alert here too?
        case EKAuthorizationStatus.Authorized:
            displayEvents()
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
        
        switch reminderAuthorizationStatus {
        case EKAuthorizationStatus.Denied:
            print("Denied")
        case EKAuthorizationStatus.Restricted:
            print("Restricted")
        case EKAuthorizationStatus.Authorized:
            print("Authorized")
            getReminders()
        case EKAuthorizationStatus.NotDetermined:
            print("Not Determined")
            eventStore?.requestAccessToEntityType(EKEntityType.Reminder, completion: {
                granted, error in
                if granted {
                    print("Access was granted")
                } else {
                    print("Access Was Denied, or error")
                    if let theError = error {
                        print("Error: \(theError.description)")
                    }
                }
            })
        }
    }
    
    func eventsForToday() -> [EKEvent] {
        let store = eventStore
        let date: NSDate = NSDate()
        let endDate: NSDate = date.dateByAddingTimeInterval(24*60*60)
        print(calendars)
        let predicate = store!.predicateForEventsWithStartDate(date, endDate: endDate, calendars: nil)
        let event: [EKEvent] = store!.eventsMatchingPredicate(predicate)
        return event
    }
    
    func displayEvents() {
        events = eventsForToday()
        tableView.reloadData()
    }
    
    
    func getReminders() {
        print("reminders")
        let predicate = eventStore!.predicateForRemindersInCalendars(calendars)
        eventStore!.fetchRemindersMatchingPredicate(predicate, completion: {
            reminder in
            for reminders in reminder!{
                print(reminders)
            }
        })
    }
    
    
    @IBAction func saveEvent (segue: UIStoryboardSegue){
       displayEvents()
    }
    
    @IBAction func cancelEntry (segue: UIStoryboardSegue){
        
    }
        
}

