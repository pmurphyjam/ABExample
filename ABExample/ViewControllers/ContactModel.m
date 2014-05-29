//
//  ContactModel.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
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

+(NSDictionary*)insertContactsSQL:(ContactObject*)contactObject
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" insert into Contacts (sync_bit,sync_delete,sync_datetime,firstName,lastName,birthDate,nameHash,emailAddress,emailHash,phoneNumber,phoneHash, accountID,contactID,company,address,city,state,numberOfItems,modificationDate,userThumbnail) values(?,?,?"];
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
    
    if([[contactObject birthDate] length] > 0)
    {
        [parameters addObject:[contactObject birthDate]];
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
    
    if([[contactObject company] length] > 0)
    {
        [parameters addObject:[contactObject company]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject address] length] > 0)
    {
        [parameters addObject:[contactObject address]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject city] length] > 0)
    {
        [parameters addObject:[contactObject city]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[contactObject state] length] > 0)
    {
        [parameters addObject:[contactObject state]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([contactObject numberOfItems] != nil)
    {
        [parameters addObject:[contactObject numberOfItems]];
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
    
    if([[contactObject userThumbnail] length] > 10)
    {
        [parameters addObject:[contactObject userThumbnail]];
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

+(BOOL)insertContact:(ContactObject*)contactObject
{
    NSDictionary *sqlAndParams = [self insertContactsSQL:contactObject];
	BOOL status = [[AppManager DataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return status;
}

+(NSMutableArray*)getContactsForView
{
    NSMutableArray *contactArray = [[AppManager DataAccess] GetRecordsForQuery:@"select * from Contacts order by lastName asc, firstName asc ",nil];
    ContactConvertor *contactConvertor = [[ContactConvertor alloc] init];
    NSMutableArray *contactConvertorArray = [contactConvertor convertToObjects:contactArray];
    return contactConvertorArray;
}

+(BOOL)updateContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager DataAccess] ExecuteStatement:@"update Contacts set sync_bit = ?,sync_delete = ?,sync_datetime = ?,accountID = ?,contactID = ?,firstName = ?,lastName = ?,emailAddress = ?,phoneNumber = ?,phoneHash = ?,emailHash = ?,birthDate = ?,modificationDate = ?,company = ?,address = ?,city = ?,state = ?,nameHash = ?, numberOfItems = ?,userThumbnail = ? where contactID = ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject nameHash],[contactObject numberOfItems],[contactObject userThumbnail],[contactObject contactID],nil];
    return status;
}

+(NSDictionary*)getContactsSectionsForViewSQL
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" select (upper(substr(lastName,1,1))) as SectionHeader, count(*) as Rows from Contacts group by SectionHeader order by lastName asc, firstName asc"];
	NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys: sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(NSMutableArray*)getContactsSectionsForView
{
    NSDictionary *sqlAndParams = [self getContactsSectionsForViewSQL];
	NSMutableArray *chatsArray = [[AppManager DataAccess] GetRecordsForQuery:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return chatsArray;
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

+(NSString*)getMD5HashedValueForPhone:(NSString*)phoneNumber
{
    //Need to get just the decimal numbers from the phone number
    NSMutableString *realPhoneNumber = [[NSMutableString alloc] init];
    NSInteger phoneNumberIndex = [phoneNumber length];
    while (phoneNumberIndex > 0)
    {
        phoneNumberIndex--;
        NSRange subStrRange = NSMakeRange(phoneNumberIndex, 1);
        NSString *numberStr = [phoneNumber substringWithRange:subStrRange];
        if ([numberStr rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
            [realPhoneNumber appendString:numberStr];
    }
    NSString *hashedValue = [DeviceUtils hashedValue:realPhoneNumber uppercase:NO];
    return hashedValue;
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
    [SettingsModel setProcessingContacts:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool
        {
            [SettingsModel setStartDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
            NSArray *contacts = [ABContactsHelper contacts];
            NSMutableArray *contactsTransaction = [[NSMutableArray alloc] init];
            NSMutableArray *uniqueContacts = [[NSMutableArray alloc] init];
            
            NCONLog(@"ContactModel : CALLED : Contacts : contacts count = %d",[contacts count]);
            //This get's all the Contacts so they can be checked for duplicates
            NSMutableArray *contactsToBeDeleted = [self getUserContactIDHashes];
            NSMutableArray *contactsToKeep = [[NSMutableArray alloc] init];
            
            int total = 0;
            //Sets the total number of transactions inserted at one time into DB
            //Newer devices can handle more, older devices can not, it's a memory limitation
            int totalTransactions = 200;
            for (ABContact *contact in contacts)
            {
                BOOL foundPhoneForContact = NO;
                NCONLog(@"ContactModel : insertUserContacts : contact = %@ %@ : Date = %@",[contact firstname],[contact lastname],[contact modificationDate]);
                ContactObject *contactObject = [[ContactObject alloc] init];
                [contactObject setFirstName:[contact firstname]];
                [contactObject setLastName:[contact lastname]];
                [contactObject setModificationDate:[AppManager getUTCDateTimeForDate:[contact modificationDate]]];
                [contactObject setNameHash:[self getMD5HashedValue:[NSString stringWithFormat:@"%@%@",[contact firstname],[contact lastname]]]];

                int numberOfItems = 2;

                if([contact birthday] != nil)
                {
                    [contactObject setBirthDate:[AppManager getBirthDatefromDate:[contact birthday]]];
                    numberOfItems++;
                }

                if([[contact lastname] length] < 1 && [[contact firstname] length] < 1)
                    continue;
                
                //If no lastname use firstname so alphabetization works properly
                if([[contact lastname] length] == 0)
                    [contactObject setLastName:[contact firstname]];
                
                if([[contact imageData] length] > 10)
                {
                    NSData *imageData = [NSData scaleDataImage:[contact imageData] toSize:CONTACT_IMAGE_SIZE];
                    [contactObject setUserThumbnail:imageData];
                    imageData = nil;
                }
                
                //Get the Company
                if([[contact organization] length] > 0)
                {
                    [contactObject setCompany:[contact organization]];
                    numberOfItems++;
                }

                //Get the Address
                NSArray *addressArray = [contact addressArray];
                if([addressArray count] > 0)
                    numberOfItems = numberOfItems + 3;

                for(NSDictionary * addressDic in addressArray)
                {
                    [contactObject setAddress:[addressDic objectForKey:@"Street"]];
                    [contactObject setState:[addressDic objectForKey:@"State"]];
                    [contactObject setCity:[addressDic objectForKey:@"City"]];
                }

                NCONLog(@"ContactModel : Name : %@ %@ numberOfItems = %d", contactObject.firstName,contactObject.lastName, numberOfItems);

                NSArray *phoneArray = [contact phoneArray];
                NCONLog(@"ContactModel : Name: %@  %@ : PhoneArray[%d] : %@", contactObject.firstName,contactObject.lastName, [phoneArray count],phoneArray);
                if([phoneArray count] > 0)
                {
                    [contactObject setEmailAddress:nil];
                    [contactObject setEmailHash:nil];
                    
                    for(NSString *phone in phoneArray)
                    {
                        //Make sure everything gets released for a user with 1000's of contacts
                        @autoreleasepool
                        {
                            foundPhoneForContact = YES;
                            NCONLog(@"ContactModel : Name : PHONE : %@ %@ : Phone : %@", contactObject.firstName,contactObject.lastName, phone);
                            
                            [contactObject setPhoneNumber:phone];
                            //Would actually get country from Phone number type here
                            //Also need to make sure we use just real phone numbers here or the MD5
                            //will always return the same value
                            NSString *phoneMD5 = [self getMD5HashedValueForPhone:phone];
                            [contactObject setPhoneHash:phoneMD5];
                            [contactObject setContactID:phoneMD5];
                            
                            if([uniqueContacts indexOfObject:phoneMD5] == NSNotFound)
                            {
                                numberOfItems++;
                                [contactObject setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
                                NCONLog(@"ContactModel : Name : PHONE : %@ %@ -- numberOfItems = %d", contactObject.firstName,contactObject.lastName, numberOfItems);
                                [uniqueContacts addObject:phoneMD5];
                                
                                BOOL contactIDExists = [self doesContactExistForContactID:phoneMD5];
                                if(contactIDExists)
                                {
                                    NSArray *contactsToRemove = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:phoneMD5 forKey:@"hash"]];
                                    phoneMD5 = nil;
                                    [contactsToBeDeleted removeObjectsInArray:contactsToRemove];
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
                                numberOfItems--;
                                [contactObject setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
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
                        //Make sure everything gets released for a user with 1000's of contacts
                        @autoreleasepool
                        {
                            [contactObject setEmailAddress:email];
                            NSString *emailMD5 = [DeviceUtils hashedValue:email uppercase:NO];
                            [contactObject setEmailHash:emailMD5];
                            [contactObject setContactID:emailMD5];
                            
                            NCONLog(@"ContactModel : Name : EMAIL : %@ -- Phone: %@", contactObject.firstName, email);
                            NCONLog(@"ContactModel : Name : EMAIL : %@ -- Stripped Phone: %@", contactObject.lastName, emailMD5);
                            
                            if([uniqueContacts indexOfObject:emailMD5] == NSNotFound)
                            {
                                numberOfItems++;
                                [contactObject setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
                                NCONLog(@"ContactModel : Name : EMAIL : %@ -- numberOfItems = %d", contactObject.firstName, numberOfItems);

                                [uniqueContacts addObject:emailMD5];
                                
                                BOOL contactIDExists = [self doesContactExistForContactID:emailMD5];
                                if(contactIDExists)
                                {
                                    NSArray *contactsToRemove = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:emailMD5 forKey:@"hash"]];
                                    [contactsToBeDeleted removeObjectsInArray:contactsToRemove];
                                    emailMD5 = nil;
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
                                numberOfItems--;
                                [contactObject setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
                            }
                        }
                    }//autoreleasepool
                }
                emailArray = nil;
                NCONLog(@"ContactModel : contactObject : %@ ",contactObject);
            }
            //remove contacts that are no longer in the Users Address Book
            //You need this to get rid of duplicates and contacts that have been deleted from the Users Address Book
            //Otherwise the user will always have contacts showing they've deleted which is not good.
            //Note : We never insert a new Address Book Contact if it is using an already existing Phone # or Email Address
            [contactsToBeDeleted removeObjectsInArray:contactsToKeep];
            
            for (NSDictionary *hashToDeleteDic in contactsToBeDeleted)
            {
                //This shows you who you are deleting, just for debug
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
            
            [SettingsModel setTotalUserContacts:[NSNumber numberWithInt:[ABContactsHelper validContactsCount]]];
            [SettingsModel setFinishDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
            NCONLog(@"ContactModel : Finished Insert [%d] : time = %f",[contactsTransaction count],[SettingsModel getStartToFinishTimeForIndex:0]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Send a notification to the Contacts view to reload
                [[NSNotificationCenter defaultCenter] postNotificationName:CONTACTS_UPDATE_NOTIFICATION object:nil];
            });
        }
    });
    [SettingsModel setProcessingContacts:NO];
	return status;
}

@end
