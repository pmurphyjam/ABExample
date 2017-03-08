//
//  CalendarAttendeeObject.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import "CalendarAttendeeObject.h"

@implementation CalendarAttendeeObject

- (NSString*)description
{
	return [NSString stringWithFormat:@"CalendarAttObj \r: calendarID = %@ \r: firstName = %@ \r: lastName = %@ \r: emailAddress = %@ \r: emailHash = %@ \r: nameHash = %@ \r: contactExists = %@",self.calendarID,self.firstName,self.lastName,self.emailAddress,self.emailHash,self.nameHash,[self.contactExists boolValue]?@"YES":@"NO"];
}

@end
