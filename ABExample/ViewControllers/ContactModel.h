//
//  ContactModel.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
// Info : Controls all accesses to the Contacts table view contrller.
// Should have an Select(get), Insert, Update, and Delete for all tables, and deal only with ContactObjects.
// Similar in construct to ORMLite for Android.
//
#import <Foundation/Foundation.h>
#import "ContactObject.h"

@interface ContactModel : NSObject

+(BOOL)insertContact:(ContactObject*)contactObject;
+(NSMutableArray*)getContactsForView;
+(NSMutableArray*)getContactsSectionsForView;
+(BOOL)updateContact:(ContactObject*)contactObject;
+(BOOL)deleteContact:(ContactObject*)contactObject;
+(BOOL)updateContactsRequired;
+(BOOL)getUserContactsFromAddressBook;
+(NSString*)getMD5HashedValue:(NSString*)value;
+(BOOL)doesContactExistForEmailHash:(NSString*)emailHash;
+(BOOL)getAccessToContacts;

@end
