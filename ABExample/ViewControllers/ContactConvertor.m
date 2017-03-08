//
//  ContactConvertor.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import "ContactConvertor.h"
#import "ContactObject.h"

@implementation ContactConvertor

-(NSMutableArray*)convertToObjects:(NSArray*)companyArray
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[companyArray count]];
    for (NSDictionary *contact  in companyArray) {
        ContactObject *contactObj = [[ContactObject alloc] init];
        contactObj.accountID = contact[@"accountID"];
        contactObj.contactID = contact[@"contactID"];
        contactObj.firstName = contact[@"firstName"];
        contactObj.lastName = contact[@"lastName"];
        contactObj.emailAddress = contact[@"emailAddress"];
        contactObj.phoneNumber = contact[@"phoneNumber"];
        contactObj.phoneHash = contact[@"phoneHash"];
        contactObj.emailHash = contact[@"emailHash"];
        contactObj.nameHash = contact[@"nameHash"];
        contactObj.birthDate = contact[@"birthDate"];
        contactObj.modificationDate = contact[@"modificationDate"];
        contactObj.company = contact[@"company"];
        contactObj.address = contact[@"address"];
        contactObj.numberOfItems = contact[@"numberOfItems"];
        contactObj.city = contact[@"city"];
        contactObj.state = contact[@"state"];
        contactObj.userThumbnail = contact[@"userThumbnail"];
        [objects addObject:contactObj];
    }
    return objects;
}

@end
