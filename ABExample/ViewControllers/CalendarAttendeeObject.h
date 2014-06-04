//
//  CalendarAttendeeObject.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Creates a CalendarAttendee Object from the DB CalendarAttendees table, 1-1 mapping.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//
#import <Foundation/Foundation.h>

@interface CalendarAttendeeObject : NSObject

@property (nonatomic,strong) NSString *calendarID;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic,strong) NSString *emailHash;
@property (nonatomic,strong) NSString *nameHash;
@property (nonatomic,strong) NSNumber *contactExists;

@end
