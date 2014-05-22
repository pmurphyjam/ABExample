//
//  ContactsTableViewController.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Contacts Table View controller. Uses a UISearchDisplayController for searching
//  for First or Last mames. Also adds indexing for quick scrolling to a desired contact.
//  Table view is sectionalized for indexing.
//  The AopDelete uses the ABContacts library to read your iphone Address Book, and these
//  contacts are then displayed in this table view controller. A contact is an single
//  phone number or email address.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;

@end
