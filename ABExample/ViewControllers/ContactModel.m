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
#import "NSData+Category.h"
#import "ABContact.h"
#import "ABContactsHelper.h"
#import "DeviceUtils.h"
#import "SettingsModel.h"

@implementation ContactModel

#import "AppConstants.h"

+(BOOL)insertContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"insert into Contacts (sync_bit,sync_delete,sync_datetime,accountID,contactID,firstName,lastName,emailAddress,phoneNumber,phoneHash,emailHash,nameHash,birthDate,modificationDate,company,address,city,state,userThumbnail) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject nameHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject userThumbnail],nil];
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
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"update Contacts set sync_bit = ?,sync_delete = ?,sync_datetime = ?,accountID = ?,contactID = ?,firstName = ?,lastName = ?,emailAddress = ?,phoneNumber = ?,phoneHash = ?,emailHash = ?,birthDate = ?,modificationDate = ?,company = ?,address = ?,city = ?,state = ?,nameHash = ?,userThumbnail = ? where contactID = ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject nameHash],[contactObject userThumbnail],[contactObject contactID],nil];
    return status;
}

+(BOOL)deleteContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"delete from Contacts where contactID = ?",[contactObject contactID],nil];
    return status;
}

+(NSMutableArray*)getUserContactIDHashes
{
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@"select coalesce(phoneHash,emailHash) as hash from Contacts ",nil];
    return contactArray;
}

+(BOOL)doesContactExistForContactID:(NSString*)contactID
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@" select contactID from Contacts where contactID = ?  ",contactID,nil];
    if([contactArray count] > 0)
        status = YES;
    return status;
}

+(BOOL)doesContactNeedUpdating:(ContactObject*)contactObject
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@" select nameHash from Contacts where contactID = ?  ",[contactObject contactID],nil];
    if([contactArray count] > 0 && ([[contactObject emailAddress] length] > 0 || [[contactObject phoneNumber] length] > 0))
    {
        NSString *nameHashStr = [[contactArray objectAtIndex:0] objectForKey:@"nameHash"];
        if([[contactObject nameHash] isEqualToString:nameHashStr])
            status = NO;
        else
        {
            status = YES;
        }
    }
    return status;
}

+(NSDictionary*)doesContactModificationDateNeedUpdatingSQL:(ContactObject*)contactObject
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" select modificationDate from Contacts where contactID = ? "];
    [parameters addObject:[contactObject contactID]];
	NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys: sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)doesContactModificationDateNeedUpdating:(ContactObject*)contactObject
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@" select modificationDate from Contacts where contactID = ? ",[contactObject contactID],nil];
    if([contactArray count] > 0 && ([[contactObject emailAddress] length] > 0 || [[contactObject phoneNumber] length] > 0))
    {
        NSString *modificationDateStr = [[contactArray objectAtIndex:0] objectForKey:@"modificationDate"];
        if([[contactObject modificationDate] isEqualToString:modificationDateStr])
            status = NO;
        else
            status = YES;
    }
    return status;
}

+(NSDictionary*) insertContactsSQL:(ContactObject*)contactObject
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" insert into Contacts (sync_bit,sync_delete,sync_datetime,firstName,lastName,nameHash,emailAddress,emailHash,phoneNumber,phoneHash, accountID,contactID,nameHash,userThumbnail,company,modificationDate) values(?,?,?"];
    [parameters addObject:[NSNumber numberWithBool:YES]];
    [parameters addObject:[NSNumber numberWithBool:NO]];
    [parameters addObject:[AppManager UTCDateTime]];
    
    //Check for existance first, default to NULL if not present
    if([[contactObject firstName] length] > 0)
    {
        [parameters addObject:[contactObject firstName]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject lastName] length] > 0)
    {
        [parameters addObject:[contactObject lastName]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject nameHash] length] > 0)
    {
        [parameters addObject:[contactObject nameHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }

    if([[contactObject emailAddress] length] > 1)
    {
        [parameters addObject:[contactObject emailAddress]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject emailHash] length] > 1)
    {
        [parameters addObject:[contactObject emailHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject phoneNumber] length] > 1)
    {
        [parameters addObject:[contactObject phoneNumber]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject phoneHash] length] > 1)
    {
        [parameters addObject:[contactObject phoneHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([contactObject accountID] != nil)
    {
        [parameters addObject:[contactObject accountID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject contactID] length] > 1)
    {
        [parameters addObject:[contactObject contactID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject nameHash] length] > 0)
    {
        [parameters addObject:[contactObject nameHash]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject userThumbnail] length] > 10)
    {
        [parameters addObject:[contactObject userThumbnail]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject company] length] > 0)
    {
        [parameters addObject:[contactObject company]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject modificationDate] length] > 0)
    {
        [parameters addObject:[contactObject modificationDate]];
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

+(NSMutableArray*)getContactsForHash:(NSString*)contactHash
{
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@" select firstName, lastName from Contacts where phoneHash = ? OR emailHash = ? ",contactHash,contactHash,nil];
    return contactArray;
}

+(BOOL)deleteUserContactForContactID:(NSString*)contactHash
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"delete from Contacts where phoneHash = ? OR emailHash = ? ",contactHash,contactHash,nil];
    return status;
}

+(NSString*)getMD5HashedValue:(NSString*)value
{
    NSString *hashedValue = [DeviceUtils hashedValue:value uppercase:NO];
    return hashedValue;
}

+(BOOL)updateContactsRequired
{
    BOOL status = NO;
    int savedContactsCount = [[SettingsModel getTotalUserContacts] intValue];
    int currentContactsCount = [ABContactsHelper validContactsCount];
    NCONLog(@"savedContactsCount = %i currentContactsCount = %i",savedContactsCount,currentContactsCount);
    if(savedContactsCount != currentContactsCount || savedContactsCount==0)
        status = YES;
    return status;
}

+(BOOL)getUserContactsFromAddressBook
{
    BOOL __block status = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool
        {
            [SettingsModel setStartDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
            [SettingsModel setProcessingContacts:YES];
            NSArray *contacts = [ABContactsHelper contacts];
            NSMutableArray *contactsTransaction = [[NSMutableArray alloc] init];
            NSMutableArray *uniqueContacts = [[NSMutableArray alloc] init];
            
            NCONLog(@"ContactModel : CALLED : Contacts : contacts count = %d",[contacts count]);
            //This get's all the UserContacts so they can be checked for duplicates
            NSMutableArray *contactsToBeDeleted = [self getUserContactIDHashes];
            //This get's all the SmugChatContacts which we never want to delete, Sarah is in here
            //All of these come from the Server in GetMessages
            NSMutableArray *contactsToKeep = [[NSMutableArray alloc] init];//[self getSmugContactIDHashes];
            
            int total = 0;
            //Sets the total number of transactions inserted at one time into DB
            //Newer devices can handle more, older devices can not, it's a memory limitation
            int totalTransactions = 200;
            
            for (ABContact *contact in contacts)
            {
                BOOL foundPhoneForContact=NO;
                NCONLog(@"ContactModel : insertUserContacts : contact = %@ %@ : Date = %@",[contact firstname],[contact lastname],[contact modificationDate]);
                ContactObject *contactObject = [[ContactObject alloc] init];
                [contactObject setFirstName:[contact firstname]];
                [contactObject setLastName:[contact lastname]];
                [contactObject setModificationDate:[AppManager getUTCDateTimeForDate:[contact modificationDate]]];
                [contactObject setNameHash:[DeviceUtils hashedValue:[NSString stringWithFormat:@"%@%@",[contact firstname],[contact lastname]] uppercase:NO]];

                if([[contact lastname] length] < 1 && [[contact firstname] length] < 1)
                    continue;
                
                //If no lastname use firstname so alphabetization works properly
                if([[contact lastname] length] == 0)
                    [contactObject setLastName:[contact firstname]];
                
                if([[contact imageData] length] > 10)
                {
                    NSData *imageData = [NSData scaleDataImage:[contact imageData] toSize:CONTACT_IMAGE_SIZE];
                    [contactObject setUserThumbnail:imageData];
                }
                
                NSArray *phoneArray = [contact phoneArray];
                NCONLog(@"ContactModel : Name: %@  %@ : PhoneArray[%d] : %@", contactObject.firstName,contactObject.lastName, [phoneArray count],phoneArray);
                if([phoneArray count] > 0)
                {
                    [contactObject setEmailAddress:nil];
                    [contactObject setEmailHash:nil];
                    for(NSString * phone in phoneArray)
                    {
                        @autoreleasepool
                        {
                            foundPhoneForContact = YES;
                            NCONLog(@"ContactModel : Name : PHONE : %@ %@ : Phone: %@", contactObject.firstName,contactObject.lastName, phone);
                            
                            [contactObject setPhoneNumber:phone];
                            //Would actually get country from Phone number type here
                            NSString *phoneMD5 = [self getMD5HashedValue:phone];
                            [contactObject setPhoneHash:phoneMD5];
                            [contactObject setContactID:phoneMD5];
                            
                            if([uniqueContacts indexOfObject:phoneMD5]==NSNotFound)
                            {
                                [uniqueContacts addObject:phoneMD5];
                                
                                BOOL contactIDExists = [self doesContactExistForContactID:phoneMD5];
                                if(contactIDExists)
                                {
                                    [contactsToKeep addObject:[NSDictionary dictionaryWithObject:phoneMD5 forKey:@"hash"]];
                                    BOOL updateContact = [self doesContactNeedUpdating:contactObject];
                                    BOOL updateContactModificationDate = [self doesContactModificationDateNeedUpdating:contactObject];
                                    NCONLog(@"ContactModel : Name : PHONE : contact Name -->'%@ %@' : updateContact = %@: updateDate = %@",[contact firstname],[contact lastname],updateContact?@"YES":@"NO",updateContactModificationDate?@"YES":@"NO");
                                    
                                    if(updateContact || updateContactModificationDate)
                                    {
                                        status = [self updateContact:contactObject];
                                        NCONLog(@"ContactModel : Name : PHONE : UPDATE contact Name -->'%@ %@'",[contact firstname],[contact lastname]);
                                    }
                                    else
                                    {
                                        NCONLog(@"ContactModel : Name : PHONE : DID NOT CHANGE -->'%@ %@'",[contact firstname],[contact lastname]);
                                    }
                                }
                                else
                                {
                                    //INSERT
                                    NSDictionary *sqlAndParamsForTransaction = [self insertContactsSQL:contactObject];
                                    NCONLog(@"ContactModel : Name : PHONE : INSERT : contactsTransaction ADDED");
                                    [contactsTransaction addObject:sqlAndParamsForTransaction];
                                    total++;
                                    if ( total > totalTransactions )
                                    {
                                        total = 0 ;
                                        [[AppManager DataAccess] ExecuteTransaction:contactsTransaction];
                                        NCONLog(@"ContactModel : Name : PHONE : UPDATE contactsTransaction 1");
                                        contactsTransaction = [[NSMutableArray alloc] init];
                                    }
                                }
                            }
                        }//autoreleasepool
                    }
                }
                phoneArray = nil;
                NSArray *emailArray = [contact emailArray];
                NCONLog(@"ContactModel : Name: %@  %@ : EmailArray[%d] : %@", contactObject.firstName,contactObject.lastName, [emailArray count],emailArray);
                if([emailArray count] > 0 && foundPhoneForContact!=YES)
                {
                    [contactObject setPhoneNumber:nil];
                    [contactObject setPhoneHash:nil];
                    for(NSString * email in emailArray)
                    {
                        @autoreleasepool
                        {
                            [contactObject setEmailAddress:email];
                            NSString *emailMD5 = [DeviceUtils hashedValue:email uppercase:NO];
                            [contactObject setEmailHash:emailMD5];
                            [contactObject setContactID:emailMD5];
                            
                            NCONLog(@"ContactModel : Name : EMAIL : %@ -- Phone: %@", contactObject.firstName, email);
                            NCONLog(@"ContactModel : Name : EMAIL : %@ -- Stripped Phone: %@", contactObject.lastName, emailMD5);
                            
                            if([uniqueContacts indexOfObject:emailMD5]==NSNotFound)
                            {
                                [uniqueContacts addObject:emailMD5];
                                
                                BOOL contactIDExists = [self doesContactExistForContactID:emailMD5];
                                if(contactIDExists)
                                {
                                    [contactsToKeep addObject:[NSDictionary dictionaryWithObject:emailMD5 forKey:@"hash"]];
                                    BOOL updateContact = [self doesContactNeedUpdating:contactObject];
                                    BOOL updateContactModificationDate = [self doesContactModificationDateNeedUpdating:contactObject];
                                    NCONLog(@"ContactModel : Name : EMAIL : contact Name -->'%@ %@' : updateContact = %@: updateDate = %@",[contact firstname],[contact lastname],updateContact?@"YES":@"NO",updateContactModificationDate?@"YES":@"NO");
                                    
                                    if(updateContact || updateContactModificationDate)
                                    {
                                        status = [self updateContact:contactObject];
                                        NCONLog(@"ContactModel : Name : EMAIL : UPDATE contact Name -->'%@ %@'",[contact firstname],[contact lastname]);
                                    }
                                    else
                                    {
                                        NCONLog(@"ContactModel : Name : EMAIL : DID NOT CHANGE -->'%@ %@'",[contact firstname],[contact lastname]);
                                    }
                                }
                                else
                                {
                                    //INSERT
                                    NSDictionary *sqlAndParamsForTransaction = [self insertContactsSQL:contactObject];
                                    NCONLog(@"ContactModel : Name : EMAIL : INSERT : contactsTransaction ADDED");
                                    [contactsTransaction addObject:sqlAndParamsForTransaction];
                                    total++;
                                    if ( total > totalTransactions )
                                    {
                                        total = 0 ;
                                        [[AppManager DataAccess] ExecuteTransaction:contactsTransaction];
                                        NCONLog(@"ContactModel : Name : EMAIL : UPDATE contactsTransaction 2 ");
                                        contactsTransaction = [[NSMutableArray alloc] init];
                                    }
                                }
                            }
                        }
                    }//autoreleasepool
                }
                emailArray = nil;
            }
            //remove contacts that are no longer in the Users Address Book
            //You need this to get rid of duplicates and contacts that have been deleted from the Users Address Book
            //Otherwise the user will always have contacts showing they've deleted which is not good.
            //Note : We never insert a new Address Book Contact if it is using an already existing Phone # or Email Address
            [contactsToBeDeleted removeObjectsInArray:contactsToKeep];
            
            for (NSDictionary *hashToDeleteDic in contactsToBeDeleted)
            {
                //This shows you who you are deleting
                NCONLog(@"ContactModel : deleteUserContactForContactID : usersDeleting = %@",[self getContactsForHash:[hashToDeleteDic objectForKey:@"hash"]]);
                [self deleteUserContactForContactID:[hashToDeleteDic objectForKey:@"hash"]];
                NCONLog(@"ContactModel : deleteUserContactsForContactID hashToDelete : %@",[hashToDeleteDic objectForKey:@"hash"]);
            }
            
            if([contactsTransaction count] > 0)
            {
                //Transaction Insert
                status = [[AppManager DataAccess] ExecuteTransaction:contactsTransaction];
                NCONLog(@"ContactModel : UPDATE contactsTransaction : status = %@ ",status?@"YES":@"NO");
            }
            
            [SettingsModel setProcessingContacts:NO];
            [SettingsModel setTotalUserContacts:[NSNumber numberWithInt:[ABContactsHelper validContactsCount]]];
            [SettingsModel setFinishDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
            NCONLog(@"ContactModel : Finished Insert [%d] : time = %f",[contactsTransaction count],[SettingsModel getStartToFinishTimeForIndex:0]);
        }
    });
	return status;
}


@end
