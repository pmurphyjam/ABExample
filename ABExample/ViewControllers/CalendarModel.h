//
//  CalendarModel.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
// Info : Controls all accesses to the Calendar table view contrller.
// Should have an Select(get), Insert, Update, and Delete for all tables, and deal only with CalendarObjects.
// Similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>
#import "CalendarObject.h"
#import "CalendarAttendeeObject.h"

@interface CalendarModel : NSObject

+(BOOL)insertCalendar:(CalendarObject*)calendarObject;
+(BOOL)insertCalendarAttendee:(CalendarAttendeeObject*)calendarAttendeeObject;
+(NSMutableArray*)getCalendarForView;
+(NSMutableArray*)getCalendarSectionsForView;
+(NSMutableArray*)getCalendarAttendeesForView:(NSString*)calendarID;
+(BOOL)updateCalendar:(CalendarObject*)calendarObject;
+(BOOL)deleteCalendar:(CalendarObject*)calendarObject;
+(BOOL)doesCalendarEventExistForCalendarID:(NSString*)calendarID;
+(BOOL)getCalendarEvents;
+(BOOL)updateCalendarRequired;
+(void)getCalendarAuthorization;

@end
