//
//  ContactObject.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Creates a Contact Object from the DB Contacts table, 1-1 mapping.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>

@interface ContactObject : NSObject

@property (nonatomic,strong) NSString *accountID;
@property (nonatomic,strong) NSString *contactID;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *phoneHash;
@property (nonatomic,strong) NSString *emailHash;
@property (nonatomic,strong) NSString *nameHash;
@property (nonatomic,strong) NSString *birthDate;
@property (nonatomic,strong) NSString *modificationDate;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSNumber *numberOfItems;
@property (nonatomic,strong) NSData *userThumbnail;

@end
