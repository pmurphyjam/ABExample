//
//  CalendarObject.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Creates a Calendar Object from the DB Calendar table, 1-1 mapping.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//
#import <Foundation/Foundation.h>

@interface CalendarObject : NSObject

@property (nonatomic,strong) NSString *eventTitle;
@property (nonatomic,strong) NSString *notes;
@property (nonatomic,strong) NSString *calendarID;
@property (nonatomic,strong) NSString *startDate;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *creationDate;
@property (nonatomic,strong) NSString *calendarDate;
@property (nonatomic,strong) NSString *eventLocation;
@property (nonatomic,strong) NSString *eventID;
@property (nonatomic,strong) NSString *modificationDate;
@property (nonatomic,strong) NSNumber *numberOfItems;
@property (nonatomic,strong) NSArray *attendeesArray;

@end
