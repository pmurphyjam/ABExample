//
//  ContactObject.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : This just prints out the ContactObject in a pretty format in an NSLog.
//  It never prints out the companyThumbnail data just it's length.
//
#import "ContactObject.h"

@implementation ContactObject

//@synthesize nameHash;

- (NSString*)description
{
	return [NSString stringWithFormat:@"ContactObj \r: accountID = %@ \r: contactID = %@ \r: firstName = %@ \r: lastName = %@ \r: emailAddress = %@ \r: phoneNumber = %@ \r: phoneHash = %@ \r: emailHash = %@ \r: nameHash = %@ \r: birthDate = %@ \r: modificationDate = %@ \r: company = %@ \r: address = %@ \r: city = %@ \r: state = %@ \r: numberOfItems[%d] \r: userThumbnail[%d] ",self.accountID,self.contactID,self.firstName,self.lastName,self.emailAddress,self.phoneNumber,self.phoneHash,self.emailHash,self.nameHash,self.birthDate,self.modificationDate,self.company,self.address,self.city,self.state,(int)[self.numberOfItems integerValue],(int)[self.userThumbnail length]];
}

@end
