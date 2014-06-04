//
//  CalendarConvertor.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CalendarConvertor.h"
#import "CalendarObject.h"
#import "CalendarAttendeeObject.h"
#import "CalendarModel.h"

@implementation CalendarConvertor

-(NSMutableArray*)convertToObjects:(NSArray*)companyArray
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[companyArray count]];
    for (NSDictionary *contact  in companyArray) {
        CalendarObject *calendarObj = [[CalendarObject alloc] init];
        calendarObj.eventTitle = contact[@"eventTitle"];
        calendarObj.notes = contact[@"notes"];
        calendarObj.calendarID = contact[@"calendarID"];
        calendarObj.startDate = contact[@"startDate"];
        calendarObj.endDate = contact[@"endDate"];
        calendarObj.creationDate = contact[@"creationDate"];
        calendarObj.calendarDate = contact[@"calendarDate"];
        calendarObj.eventLocation = contact[@"eventLocation"];
        calendarObj.eventID = contact[@"eventID"];
        calendarObj.modificationDate = contact[@"modificationDate"];
        calendarObj.numberOfItems = contact[@"numberOfItems"];
        calendarObj.attendeesArray = [CalendarModel getCalendarAttendeesForView:[calendarObj calendarID]];
        [objects addObject:calendarObj];
    }
    return objects;
}

-(NSMutableArray*)convertToAttendeeObjects:(NSArray*)companyArray
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[companyArray count]];
    for (NSDictionary *contact  in companyArray) {
        CalendarAttendeeObject *calendarAttendeeObj = [[CalendarAttendeeObject alloc] init];
        calendarAttendeeObj.calendarID = contact[@"calendarID"];
        calendarAttendeeObj.firstName = contact[@"firstName"];
        calendarAttendeeObj.lastName = contact[@"lastName"];
        calendarAttendeeObj.emailAddress = contact[@"emailAddress"];
        calendarAttendeeObj.emailHash = contact[@"emailHash"];
        calendarAttendeeObj.nameHash = contact[@"nameHash"];
        calendarAttendeeObj.contactExists = contact[@"contactExists"];
        [objects addObject:calendarAttendeeObj];
    }
    return objects;
}

@end
