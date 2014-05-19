//
//  ContactModel.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import "ContactModel.h"
#import "AppManager.h"
#import "ContactConvertor.h"

@implementation ContactModel

+(BOOL)insertContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"insert into Contacts (sync_bit,sync_delete,sync_datetime,accountID,contactID,firstName,lastName,emailAddress,phoneNumber,phoneHash,emailHash,birthDate,modificationDate,company,address,city,state,userThumbnail) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject userThumbnail],nil];
    return status;
}

+(NSMutableArray*)getContactsForView
{
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@"select * from Contacts",nil];
    ContactConvertor *contactConvertor = [[ContactConvertor alloc] init];
    NSMutableArray *contactConvertorArray = [contactConvertor convertToObjects:contactArray];
    return contactConvertorArray;
}

+(BOOL)updateContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"update Contacts set sync_bit = ?,sync_delete = ?,sync_datetime = ?,accountID = ?,contactID = ?,firstName = ?,lastName = ?,emailAddress = ?,phoneNumber = ?,phoneHash = ?,emailHash = ?,birthDate = ?,modificationDate = ?,company = ?,address = ?,city = ?,state = ?,userThumbnail = ? where contactID = ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject userThumbnail],[contactObject contactID],nil];
    return status;
}

+(BOOL)deleteContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"delete from Contacts where contactID = ?",[contactObject contactID],nil];
    return status;
}

@end
