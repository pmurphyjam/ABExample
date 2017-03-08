//
//  ContactsTableViewController.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Contacts Table View controller. Uses a UISearchDisplayController for searching
//  for First or Last mames. Also adds indexing for quick scrolling to a desired contact.
//  Table view is sectionalized for indexing, and has alpha section headers.
//  The Address Book contact count is checked in viewWillAppear, if it is different, the
//  Address Book is processed again, thus the table view should always show what's in
//  your Address Book. A contact is counted as an single phone number or email address.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;

@end
