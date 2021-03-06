//
//  CalendarModel.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import "CalendarModel.h"
#import "ContactModel.h"
#import "CalendarAttendeeObject.h"
#import "AppManager.h"
#import "CalendarConvertor.h"
#import "NSData+Category.h"
#import "AppDateFormatter.h"
#import "NSString+Category.h"
#import "SettingsModel+Category.h"

#import <EventKit/EventKit.h>

@implementation CalendarModel

#import "ABConstants.h"

static EKEventStore *eventStore;

+(NSDictionary*)insertCalendarSQL:(CalendarObject*)calendarObject
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" insert into Calendar (sync_bit,sync_delete,sync_datetime,eventTitle,notes,calendarID,startDate,endDate,creationDate,calendarDate,eventLocation, eventID,modificationDate,numberOfItems) values(?,?,?"];
    [parameters addObject:[NSNumber numberWithBool:YES]];
    [parameters addObject:[NSNumber numberWithBool:NO]];
    [parameters addObject:[AppManager UTCDateTime]];
    
    //Check for existance first, default to NULL if not present
    if([[calendarObject eventTitle] length] > 0)
    {
        [parameters addObject:[calendarObject eventTitle]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject notes] length] > 0)
    {
        [parameters addObject:[calendarObject notes]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject calendarID] length] > 0)
    {
        [parameters addObject:[calendarObject calendarID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject startDate] length] > 0)
    {
        [parameters addObject:[calendarObject startDate]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject endDate] length] > 1)
    {
        [parameters addObject:[calendarObject endDate]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject creationDate] length] > 1)
    {
        [parameters addObject:[calendarObject creationDate]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject calendarDate] length] > 1)
    {
        [parameters addObject:[calendarObject calendarDate]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject eventLocation] length] > 1)
    {
        [parameters addObject:[calendarObject eventLocation]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject eventID] length] > 1)
    {
        [parameters addObject:[calendarObject eventID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarObject modificationDate] length] > 1)
    {
        [parameters addObject:[calendarObject modificationDate]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([calendarObject numberOfItems] != nil)
    {
        [parameters addObject:[calendarObject numberOfItems]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    [sql appendString:@")"];
    
    NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys:sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)insertCalendar:(CalendarObject*)calendarObject
{
    NSDictionary *sqlAndParams = [self insertCalendarSQL:calendarObject];
	BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    for(CalendarAttendeeObject *calendarAttendees in calendarObject.attendeesArray)
    {
        [self insertCalendarAttendee:calendarAttendees];
    }
    return status;
}

+(NSDictionary*)insertCalendarAttendeeSQL:(CalendarAttendeeObject*)calendarAttendeeObject
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" insert into CalendarAttendees (sync_bit,sync_delete,sync_datetime,calendarID,firstName,lastName,emailAddress,emailHash,nameHash,contactExists) values(?,?,?"];
    [parameters addObject:[NSNumber numberWithBool:YES]];
    [parameters addObject:[NSNumber numberWithBool:NO]];
    [parameters addObject:[AppManager UTCDateTime]];
    
    //Check for existance first, default to NULL if not present
    if([[calendarAttendeeObject calendarID] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject calendarID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarAttendeeObject firstName] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject firstName]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarAttendeeObject lastName] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject lastName]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarAttendeeObject emailAddress] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject emailAddress]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarAttendeeObject emailHash] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject emailHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[calendarAttendeeObject nameHash] length] > 0)
    {
        [parameters addObject:[calendarAttendeeObject nameHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([calendarAttendeeObject contactExists] != nil)
    {
        [parameters addObject:[calendarAttendeeObject contactExists]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    [sql appendString:@")"];
    
    NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys:sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)insertCalendarAttendee:(CalendarAttendeeObject*)calendarAttendeeObject
{
    NSDictionary *sqlAndParams = [self insertCalendarAttendeeSQL:calendarAttendeeObject];
	BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return status;
}

+(NSMutableArray*)getCalendarAttendeesForView:(NSString*)calendarID
{
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@"select * from CalendarAttendees where calendarID = ? ",calendarID,nil];
    CalendarConvertor *calendarConvertor = [[CalendarConvertor alloc] init];
    NSMutableArray *calendarConvertorArray = [calendarConvertor convertToAttendeeObjects:calendarArray];
    return calendarConvertorArray;
}

+(NSMutableArray*)getCalendarForView
{
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@"select * from Calendar order by Datetime(startDate, 'localtime') asc",nil];
    CalendarConvertor *calendarConvertor = [[CalendarConvertor alloc] init];
    NSMutableArray *calendarConvertorArray = [calendarConvertor convertToObjects:calendarArray];
    return calendarConvertorArray;
}

+(NSMutableArray*)getCalendarSectionsForView
{
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select calendarDate as SectionHeader, count(*) as Rows from Calendar group by startDate order by Datetime(startDate, 'localtime') asc",nil];
    return calendarArray;
}

+(BOOL)updateCalendar:(CalendarObject*)calendarObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"update Calendar set sync_bit = ?,sync_delete = ?,sync_datetime = ?,eventTitle = ?,notes = ?,calendarID = ?,startDate = ?,endDate = ?,creationDate = ?,calendarDate = ?,eventLocation = ?,eventID = ?,modificationDate = ?, numberOfItems = ? where calendarID= ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[calendarObject eventTitle],[calendarObject notes],[calendarObject calendarID],[calendarObject startDate],[calendarObject endDate],[calendarObject creationDate],[calendarObject calendarDate],[calendarObject eventLocation],[calendarObject eventID],[calendarObject modificationDate],[calendarObject numberOfItems],[calendarObject calendarID],nil];
    return status;
}

+(BOOL)deleteCalendar:(CalendarObject*)calendarObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"delete from Calendar where calendarID = ?",[calendarObject calendarID],nil];
    return status;
}

+(BOOL)doesCalendarEventExistForCalendarID:(NSString*)calendarID
{
    BOOL status = NO;
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select calendarID from Calendar where calendarID = ? ",calendarID,nil];
    if([calendarArray count] > 0)
        status = YES;
    return status;
}

+(int)getNumberOfCalendarEvents
{
    int count = 0;
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select calendarID from Calendar ",nil];
    if([calendarArray count] > 0)
        count = (int)[calendarArray count];
    return count;
}



+(BOOL)doesCalendarCreationDateNeedUpdating:(NSString*)calendarID andCreationDate:(NSString*)creationDate
{
    BOOL status = NO;
    NSMutableArray *calendarArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select creationDate from Calendar where calendarID = ?",calendarID,nil];
    if([calendarArray count] > 0)
    {
        NSString *creationDateStr = [[calendarArray objectAtIndex:0] objectForKey:@"creationDate"];
        if([creationDate isEqualToString:creationDateStr])
            status = NO;
        else
            status = YES;
    }
    return status;
}

+(NSString *) getMediumDatefromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    [dateFormatterInst setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatterInst setTimeStyle:NSDateFormatterNoStyle];
    NSString *datetime = [dateFormatterInst stringFromDate:date];
    return datetime;
}

+(NSString*) getDateStringFromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *UTCDatetime = [dateFormatterInst stringFromDate:date];
    return UTCDatetime;
}

+(NSString *) getMediumDateWithDayOfWeekfromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    [dateFormatterInst setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatterInst setTimeStyle:NSDateFormatterNoStyle];
    NSString *datetime = [dateFormatterInst stringFromDate:date];
    AppDateFormatter *dayOfWeekFormatterInst = [[AppDateFormatter alloc] init];
    [dayOfWeekFormatterInst setDateFormat:@"EEE"];
    NSString *dayOfWeek = [dayOfWeekFormatterInst stringFromDate:date];
    datetime = [datetime stringByAppendingFormat:@":%@",dayOfWeek];
    return datetime;
}

+(NSString *) currentDateTime
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *UTCDatetime = [dateFormatterInst stringFromDate:[NSDate date]];
    return UTCDatetime;
}

+(NSDate*) getDateFromDateString:(NSString*)dateStr
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSDate *UTCDatetime = [dateFormatterInst dateFromString:dateStr];
    return UTCDatetime;
}

+(BOOL)getCalendarEvents
{
    BOOL status = NO;
    [SettingsModel setProcessingCalendarEvents:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *calendars = [eventStore calendarsForEntityType:EKEntityTypeEvent];
        NSDate *today = [NSDate date];
        int betweenDays = 60;
        NSDate *startDate = [today dateByAddingTimeInterval:-60*60*24*betweenDays];
        NSDate *endDate = [today dateByAddingTimeInterval:60*60*24*betweenDays];
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                                                                     endDate:endDate
                                                                   calendars:calendars];
        NSArray *calendarEvents = [eventStore eventsMatchingPredicate:predicate];
        BOOL insertCalendarEvent = NO;
        int calendarEventCount = 0;
        
        for(EKEvent *existingEvent in calendarEvents)
        {
            if([[existingEvent attendees] count] > 0)
            {
                NSMutableArray *attendeesArray = [[NSMutableArray alloc] init];
                CalendarObject *calendarObject = [[CalendarObject alloc] init];
                int numberOfItems = 2;
                for(EKParticipant *participant in [existingEvent attendees])
                {
                    NCALLog(@"CalendarModel : participant = %@",participant);
                    NCALLog(@"CalendarModel : name = %@",participant.name);
                    NSString *participantName = participant.name;
                    NSArray *nameComponents = [participantName componentsSeparatedByString:@" "];
                    NSString *firstName = @"";
                    NSString *lastName = @"";
                    BOOL calendarIDExists = NO;
                    if([nameComponents count] > 0)
                    {
                        firstName = [nameComponents objectAtIndex:0];
                        if([nameComponents count] > 1)
                            lastName = [nameComponents objectAtIndex:1];
                        
                        calendarIDExists = [CalendarModel doesCalendarEventExistForCalendarID:existingEvent.eventIdentifier];
                        BOOL calendarCreationDateUpdate = [CalendarModel doesCalendarCreationDateNeedUpdating:existingEvent.eventIdentifier andCreationDate:[CalendarModel getDateStringFromDate:existingEvent.creationDate]];
                        NCALLog(@"CalendarModel : calendarIDExists = %@ : calendarCreationDateUpdate = %@",calendarIDExists?@"YES":@"NO",calendarCreationDateUpdate?@"YES":@"NO");
                        BOOL allDayEvent = [existingEvent isAllDay];
                        int participants = [[existingEvent attendees] count];
                        //Don't store all day events because their usually Holidays unless they have more than 2 participants
                        if(((!allDayEvent || (allDayEvent && participants > 2)) && !calendarIDExists) || calendarCreationDateUpdate)
                            insertCalendarEvent = YES;
                        
                        if(insertCalendarEvent)
                        {
                            CalendarAttendeeObject *calendarAttendeeObject = [[CalendarAttendeeObject alloc] init];
                            
                            if([existingEvent.location length] > 0)
                                numberOfItems++;
                                                        
                            [calendarObject setStartDate:[CalendarModel getDateStringFromDate:existingEvent.startDate]];
                            [calendarObject setEndDate:[CalendarModel getDateStringFromDate:existingEvent.endDate]];
                            [calendarObject setCreationDate:[CalendarModel getDateStringFromDate:existingEvent.creationDate]];
                            [calendarObject setCalendarDate:[CalendarModel getMediumDateWithDayOfWeekfromDate:existingEvent.startDate]];
                            [calendarObject setEventTitle:existingEvent.title];
                            [calendarObject setEventLocation:existingEvent.location];
                            [calendarObject setEventID:existingEvent.eventIdentifier];
                            [calendarObject setCalendarID:existingEvent.eventIdentifier];
                            [calendarObject setModificationDate:[CalendarModel currentDateTime]];
                            [calendarObject setNotes:existingEvent.notes];
                            [calendarObject setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
                            [calendarAttendeeObject setFirstName:firstName];
                            [calendarAttendeeObject setLastName:lastName];
                            [calendarAttendeeObject setCalendarID:existingEvent.eventIdentifier];
                            NSString *email = [[participant URL] absoluteString];
                            NSRange range = [email rangeOfString:@"mailto:"];
                            email = [email substringFromIndex:range.length];
                            NSString *emailMD5 = [NSString hashedValue:email uppercase:NO];
                            [calendarAttendeeObject setEmailHash:emailMD5];
                            [calendarAttendeeObject setNameHash:[NSString hashedValue:[NSString stringWithFormat:@"%@%@",[firstName lowercaseString],[lastName lowercaseString]] uppercase:NO]];
                            BOOL contactIDEmailExists = [ContactModel doesContactExistForEmailHash:emailMD5];
                            [calendarAttendeeObject setContactExists:[NSNumber numberWithBool:contactIDEmailExists]];
                            NCALLog(@"CalendarModel : insertCalendarEvent = %@ : email = %@",insertCalendarEvent?@"YES":@"NO",email);
                            [calendarAttendeeObject setEmailAddress:email];
                            [attendeesArray addObject:calendarAttendeeObject];
                            
                            if([existingEvent.location length] > 0)
                                numberOfItems--;
                        }
                    }
                }
                if(insertCalendarEvent)
                {
                    [calendarObject setAttendeesArray:attendeesArray];
                    [CalendarModel insertCalendar:calendarObject];
                    insertCalendarEvent = NO;
                    calendarEventCount++;
                    [SettingsModel setTotalCalendarEvents:[NSNumber numberWithInt:calendarEventCount]];
                    NCALLog(@"CalendarModel : calendarObject[%d] = %@",calendarEventCount,calendarObject);
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Send a notification to the Calendar view to reload
            [[NSNotificationCenter defaultCenter] postNotificationName:CALENDAR_UPDATE_NOTIFICATION object:nil];
        });
    });
    [SettingsModel setProcessingCalendarEvents:NO];
    return status;
}

+(void)getCalendarAuthorization
{
    eventStore = [[EKEventStore alloc] init];
    BOOL needsToRequestAccessToEventStore = NO;
    EKAuthorizationStatus authorizationStatus = EKAuthorizationStatusAuthorized;
    if ([[EKEventStore class] respondsToSelector:@selector(authorizationStatusForEntityType:)])
    {
        authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
    }
    if (needsToRequestAccessToEventStore)
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // You can use the event store now
                    [SettingsModel setCalendarAuthorization:YES];
                    NCALLog(@"CalendarModel : getCalendarAuthorization : GRANTED");
                    [CalendarModel getCalendarEvents];
                });
            }
        }];
    }
    else if (authorizationStatus == EKAuthorizationStatusAuthorized)
    {
        // You can use the event store now
        [SettingsModel setCalendarAuthorization:YES];
        NCALLog(@"CalendarModel : getCalendarAuthorization : AUTHORIZED");
        [CalendarModel getCalendarEvents];
    }
    else
    {
        // Access denied
        [SettingsModel setCalendarAuthorization:NO];
        NCALLog(@"CalendarModel : getCalendarAuthorization : DENIED");
    }
}

+(int)validCalendarEventCount
{
    int calendarCount = 0;
    if([SettingsModel getCalendarAuthorization])
    {
        NSArray *calendars = [eventStore calendarsForEntityType:EKEntityTypeEvent];
        NSDate *today = [NSDate date];
        int betweenDays = 60;
        BOOL calendarIDExists = NO;
        BOOL insertCalendarEvent = NO;
        NSMutableArray *eventExistsArray = [NSMutableArray new];
        NSDate *startDate = [today dateByAddingTimeInterval:-60*60*24*betweenDays];
        NSDate *endDate = [today dateByAddingTimeInterval:60*60*24*betweenDays];
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                                                                     endDate:endDate
                                                                   calendars:calendars];
        NSArray *calendarEvents = [eventStore eventsMatchingPredicate:predicate];
        for(EKEvent *existingEvent in calendarEvents)
        {
            if([[existingEvent attendees] count] > 0)
            {
                BOOL allDayEvent = [existingEvent isAllDay];
                calendarIDExists = [CalendarModel doesCalendarEventExistForCalendarID:existingEvent.eventIdentifier];
                BOOL calendarCreationDateUpdate = [CalendarModel doesCalendarCreationDateNeedUpdating:existingEvent.eventIdentifier andCreationDate:[CalendarModel getDateStringFromDate:existingEvent.creationDate]];
                int participants = [[existingEvent attendees] count];
                BOOL eventExists = NO;
                insertCalendarEvent = NO;

                //Check for re-occuring Calendar events and count them just once
                if(![eventExistsArray containsObject:existingEvent.eventIdentifier])
                {
                    [eventExistsArray addObject:existingEvent.eventIdentifier];
                    eventExists = YES;
                }
                NCALLog(@"CalendarModel : validCalendarEventCount : eventExists = %@ : calendarCreationDateUpdate = %@",eventExists?@"YES":@"NO",calendarCreationDateUpdate?@"YES":@"NO");

                if(((!allDayEvent || (allDayEvent && participants > 2)) && eventExists) || calendarCreationDateUpdate)
                    insertCalendarEvent = YES;
            
                //Don't insert all day iCal events since their holidays and they always have no attendees
                if(insertCalendarEvent)
                {
                    calendarCount++;
                }
            }
        }
    }
    return calendarCount;
}

+(BOOL)updateCalendarRequired
{
    BOOL status = NO;
    if([SettingsModel getCalendarAuthorization])
    {
        int savedEventsCount = [self getNumberOfCalendarEvents];
        int currentEventsCount = [self validCalendarEventCount];
        if((savedEventsCount != currentEventsCount) || savedEventsCount == 0)
            status = YES;
        NCALLog(@"CalendarModel : updateCalendarRequired = %@ : savedEventsCount = %d currentEventsCount = %d",status?@"YES":@"NO",savedEventsCount,currentEventsCount);
    }
    return status;
}

@end
