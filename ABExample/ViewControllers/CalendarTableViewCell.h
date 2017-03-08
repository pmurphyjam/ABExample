//
//  CalendarTableViewCell.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Calendar Table View Cell, just displays all the calendar events.
//  Uses a Nib for intial layout, dynamic layout takes place in cellForRow.
//
#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *time;
@property(nonatomic,strong) IBOutlet UILabel *timeIndicator;
@property(nonatomic,strong) IBOutlet UILabel *eventTitle;
@property(nonatomic,strong) IBOutlet UILabel *notes;
@property(nonatomic,strong) IBOutlet UILabel *eventLocation;
@property(nonatomic,strong) IBOutlet UILabel *attendees;

@end
