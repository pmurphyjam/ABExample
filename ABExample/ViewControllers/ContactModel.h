//
//  ContactModel.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
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

@end
