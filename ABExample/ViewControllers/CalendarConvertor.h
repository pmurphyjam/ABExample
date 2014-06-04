//
//  CalendarConvertor.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Calendar Convertor. Creates CalendarObject's from the DB.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>

@interface CalendarConvertor : NSObject

-(NSMutableArray*)convertToObjects:(NSArray*)contactsArray;
-(NSMutableArray*)convertToAttendeeObjects:(NSArray*)companyArray;

@end
