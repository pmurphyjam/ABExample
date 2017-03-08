//
//  ContactConvertor.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Contact Convertor. Creates ContactObject's from the DB.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>

@interface ContactConvertor : NSObject

-(NSMutableArray*)convertToObjects:(NSArray*)contactsArray;

@end
