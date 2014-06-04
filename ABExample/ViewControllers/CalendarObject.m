//
//  CalendarObject.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CalendarObject.h"

@implementation CalendarObject

- (NSString*)description
{
	return [NSString stringWithFormat:@"CalendarObj \r: eventTitle = %@ \r: notes = %@ \r: calendarID = %@ \r: startDate = %@ \r: endDate = %@ \r: creationDate = %@ \r: calendarDate = %@  \r: eventLocation = %@ \r: eventID = %@ \r: modificationDate = %@ \r: numberOfItems[%d] \r: attendeesArray[%d] = %@",self.eventTitle,self.notes,self.calendarID,self.startDate,self.endDate,self.creationDate,self.calendarDate,self.eventLocation,self.eventID,self.modificationDate,(int)[self.numberOfItems integerValue],(int)[self.attendeesArray count],self.attendeesArray ];
}

@end
