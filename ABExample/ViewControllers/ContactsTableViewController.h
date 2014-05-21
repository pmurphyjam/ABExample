//
//  ContactsTableViewController.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchDisplayController;

@end
