//
//  CalendarTableViewController.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Calendar Table View controller. Uses a UISearchDisplayController for searching
//  for event title or location. Also adds month indexing for quick scrolling to a desired contact.
//  Table view is sectionalized for indexing, and has date section headers.
//  The Calendar event count is checked in viewWillAppear, if it is different, the
//  Calendar events are processed again looking for new or changed entries.
//  The Calendar table view should always show what's in your Calendar. A Calendar event
//  is any non-allday event with invitees, thus holiday events are not counted.
//
#import <UIKit/UIKit.h>
@interface CalendarTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *modeBarButton;

- (IBAction)todayButtonAction:(id)sender;

@end
