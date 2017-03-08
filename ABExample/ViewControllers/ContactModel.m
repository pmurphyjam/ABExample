//
//  ContactModel.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import "ContactModel.h"
#import "AppManager.h"
#import "ContactConvertor.h"
#import "NSData+Category.h"
#import "NSString+Category.h"
#import <Contacts/Contacts.h>
#import "SettingsModel+Category.h"
#import "AppDateFormatter.h"

@implementation ContactModel

#import "ABConstants.h"
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
	BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return status;
}

+(NSMutableArray*)getContactsForView
{
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@"select * from Contacts order by lastName asc, firstName asc ",nil];
    ContactConvertor *contactConvertor = [[ContactConvertor alloc] init];
    NSMutableArray *contactConvertorArray = [contactConvertor convertToObjects:contactArray];
    return contactConvertorArray;
}

+(BOOL)updateContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"update Contacts set sync_bit = ?,sync_delete = ?,sync_datetime = ?,accountID = ?,contactID = ?,firstName = ?,lastName = ?,emailAddress = ?,phoneNumber = ?,phoneHash = ?,emailHash = ?,birthDate = ?,modificationDate = ?,company = ?,address = ?,city = ?,state = ?,nameHash = ?, numberOfItems = ?,userThumbnail = ? where contactID = ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[contactObject accountID],[contactObject contactID],[contactObject firstName],[contactObject lastName],[contactObject emailAddress],[contactObject phoneNumber],[contactObject phoneHash],[contactObject emailHash],[contactObject birthDate],[contactObject modificationDate],[contactObject company],[contactObject address],[contactObject city],[contactObject state],[contactObject nameHash],[contactObject numberOfItems],[contactObject userThumbnail],[contactObject contactID],nil];
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
	NSMutableArray *chatsArray = [[AppManager SQLDataAccess] GetRecordsForQuery:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return chatsArray;
}

+(BOOL)deleteContact:(ContactObject*)contactObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"delete from Contacts where contactID = ?",[contactObject contactID],nil];
    return status;
}

+(NSMutableArray*)getUserContactIDHashes
{
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@"select coalesce(phoneHash,emailHash) as hash from Contacts ",nil];
    return contactArray;
}

+(BOOL)doesContactExistForContactID:(NSString*)contactID
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select contactID from Contacts where contactID = ?  ",contactID,nil];
    if([contactArray count] > 0)
        status = YES;
    return status;
}

+(BOOL)doesContactNeedUpdating:(ContactObject*)contactObject
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select nameHash from Contacts where contactID = ?  ",[contactObject contactID],nil];
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
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select modificationDate from Contacts where contactID = ? ",[contactObject contactID],nil];
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
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select firstName, lastName from Contacts where phoneHash = ? OR emailHash = ? ",contactHash,contactHash,nil];
    return contactArray;
}

+(BOOL)deleteUserContactForContactID:(NSString*)contactHash
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"delete from Contacts where phoneHash = ? OR emailHash = ? ",contactHash,contactHash,nil];
    return status;
}

+(BOOL)doesContactExistForEmailHash:(NSString*)emailHash
{
    BOOL status = NO;
    NSMutableArray *contactArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@" select emailHash from Contacts where emailHash = ? ",emailHash,nil];
    if([contactArray count] > 0)
        status = YES;
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
    NSString *hashedValue = [NSString hashedValue:realPhoneNumber uppercase:NO];
    return hashedValue;
}

+(NSString*)getMD5HashedValue:(NSString*)value
{
    NSString *hashedValue = [NSString hashedValue:value uppercase:NO];
    return hashedValue;
}

+(BOOL)getAccessToContacts
{
    BOOL  status = NO;
    CNAuthorizationStatus contactStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if( contactStatus == CNAuthorizationStatusDenied || contactStatus == CNAuthorizationStatusRestricted)
    {
        NELog(@"ContactModel : Access Denied!");
    }
    else
    {
        NELog(@"ContactModel : Access Granted!");
        status = YES;
    }
    return status;
}

+(int)getValidContactsCount
{
    int __block intValue = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted == YES)
         {
             NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
             NSString *containerId = store.defaultContainerIdentifier;
             NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
             NSError *error;
             NSArray *contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
             for (CNContact *contact in contacts)
             {
                 intValue += [[contact phoneNumbers] count];
                 intValue += [[contact emailAddresses] count];
             }
             NCONLog(@"ContactModel : getValidContactsCount : intValue = %i ",intValue);
             dispatch_semaphore_signal(semaphore);
         }
     }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NCONLog(@"ContactModel : getValidContactsCount : return : intValue = %i ",intValue);
    return intValue;
}

+(BOOL)updateContactsRequired
{
    BOOL status = NO;
    int savedContactsCount = [[SettingsModel getTotalUserContacts] intValue];
    int currentContactsCount = [self getValidContactsCount];
    NCONLog(@"ContactModel : savedContactsCount = %i currentContactsCount = %i",savedContactsCount,currentContactsCount);
    if(savedContactsCount != currentContactsCount || savedContactsCount==0)
        status = YES;
    return status;
}

+(NSString *) getBirthDatefromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatter = [[AppDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *datetime = [dateFormatter stringFromDate:date];
    return datetime;
}

+(BOOL)getUserContactsFromAddressBook
{
    BOOL __block status = NO;
    [SettingsModel setProcessingContacts:YES];
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted == YES)
         {
             //keys with fetching properties
             int totalContacts = 0;
             NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
             NSString *containerId = store.defaultContainerIdentifier;
             NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
             NSError *error;
             NSArray *contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
             if (error)
             {
                 NELog(@"ContactModel : error fetching contacts %@", error.description);
             }
             else
             {
                @autoreleasepool
                {
                    [SettingsModel setStartDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
                    NSMutableArray *contactsTransaction = [[NSMutableArray alloc] init];
                    NSMutableArray *uniqueContacts = [[NSMutableArray alloc] init];
                    
                    NCONLog(@"ContactModel : CALLED : Contacts : contacts count = %ld",[contacts count]);
                    //This get's all the Contacts so they can be checked for duplicates
                    NSMutableArray *contactsToBeDeleted = [self getUserContactIDHashes];
                    NSMutableArray *contactsToKeep = [[NSMutableArray alloc] init];
                    
                    int total = 0;
                    //Sets the total number of transactions inserted at one time into DB
                    //Newer devices can handle more, older devices can not, it's a memory limitation
                    int totalTransactions = 200;
                    for (CNContact *contact in contacts)
                    {
                        BOOL foundPhoneForContact = NO;
                        NCONLog(@"ContactModel : insertUserContacts : contact = %@ %@ ",[contact givenName],[contact familyName]);
                        ContactObject *contactObject = [[ContactObject alloc] init];
                        [contactObject setFirstName:[contact givenName]];
                        [contactObject setLastName:[contact familyName]];
                        //[contactObject setModificationDate:[AppManager getUTCDateTimeForDate:[contact modificationDate]]];
                        [contactObject setNameHash:[self getMD5HashedValue:[NSString stringWithFormat:@"%@%@",[contact givenName],[contact familyName]]]];

                        int numberOfItems = 2;

                        if([contact birthday] != nil)
                        {
                            [contactObject setBirthDate:[ContactModel getBirthDatefromDate:[[contact birthday] date]]];
                            numberOfItems++;
                        }

                        if([[contact familyName] length] < 1 && [[contact givenName] length] < 1)
                            continue;
                        
                        //If no lastname use firstname so alphabetization works properly
                        if([[contact familyName] length] == 0)
                            [contactObject setLastName:[contact givenName]];
                        
                        if([[contact imageData] length] > 10)
                        {
                            NSData *imageData = [NSData scaleDataImage:[contact imageData] toSize:CONTACT_IMAGE_SIZE];
                            [contactObject setUserThumbnail:imageData];
                            imageData = nil;
                        }
                        
                        //Get the Company
                        if([contact organizationName] != nil)
                        {
                            if([[contact organizationName] length] > 0)
                            {
                                [contactObject setCompany:[contact organizationName]];
                                numberOfItems++;
                            }
                        }

                        //Get the Address
                        NSArray *addressArray = [contact postalAddresses];
                        if([addressArray count] > 0)
                            numberOfItems = numberOfItems + 3;

                        NSArray *addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
                        if (addresses.count > 0) {
                            for (CNPostalAddress *address in addresses)
                            {
                                [contactObject setAddress:[address street]];
                                [contactObject setState:[address state]];
                                [contactObject setCity:[address city]];
                            }
                        }
                        
                        NCONLog(@"ContactModel : Name : %@ %@ numberOfItems = %d", contactObject.firstName,contactObject.lastName, numberOfItems);

                        NSArray *phoneArray = [contact phoneNumbers];
                        NCONLog(@"ContactModel : Name: %@  %@ : PhoneArray[%ld] : %@", contactObject.firstName,contactObject.lastName, [phoneArray count],phoneArray);
                        if([phoneArray count] > 0)
                        {
                            //totalContacts += [phoneArray count];
                            [contactObject setEmailAddress:nil];
                            [contactObject setEmailHash:nil];
                            
                            for(CNLabeledValue<CNPhoneNumber*> *phone in phoneArray)
                            {
                                //Make sure everything gets released for a user with 1000's of contacts
                                @autoreleasepool
                                {
                                    foundPhoneForContact = YES;
                                    NCONLog(@"ContactModel : Name : PHONE : %@ %@ : Phone : %@", contactObject.firstName,contactObject.lastName, [[phone value] stringValue]);
                                    
                                    [contactObject setPhoneNumber:[[phone value] stringValue]];
                                    //Would actually get country from Phone number type here
                                    //Also need to make sure we use just real phone numbers here or the MD5
                                    //will always return the same value
                                    NSString *phoneMD5 = [self getMD5HashedValueForPhone:[[phone value] stringValue]];
                                    [contactObject setPhoneHash:phoneMD5];
                                    [contactObject setContactID:phoneMD5];
                                    totalContacts++;
                                    NCONLog(@"ContactModel : Name : %@ %@ : totalContacts : %d", contactObject.firstName,contactObject.lastName, totalContacts);
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
                                            NCONLog(@"ContactModel : Name : PHONE : contact Name -->'%@ %@' : updateContact = %@: updateDate = %@",[contact givenName],[contact familyName],updateContact?@"YES":@"NO",updateContactModificationDate?@"YES":@"NO");
                                            
                                            if(updateContact || updateContactModificationDate)
                                            {
                                                status = [self updateContact:contactObject];
                                                NCONLog(@"ContactModel : Name : PHONE : UPDATE contact Name -->'%@ %@'",[contact givenName],[contact familyName]);
                                            }
                                            else
                                            {
                                                NCONLog(@"ContactModel : Name : PHONE : DID NOT CHANGE -->'%@ %@'",[contact givenName],[contact familyName]);
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
                                                [[AppManager SQLDataAccess] ExecuteTransaction:contactsTransaction];
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
                        NSArray *emailArray = [contact emailAddresses];
                        NCONLog(@"ContactModel : Name: %@  %@ : EmailArray[%ld] : %@", contactObject.firstName,contactObject.lastName, [emailArray count],emailArray);
                        if([emailArray count] > 0 && foundPhoneForContact!=YES)
                        {
                            //totalContacts += [emailArray count];
                            [contactObject setPhoneNumber:nil];
                            [contactObject setPhoneHash:nil];
                            for(CNLabeledValue *email in emailArray)
                            {
                                //Make sure everything gets released for a user with 1000's of contacts
                                @autoreleasepool
                                {
                                    [contactObject setEmailAddress:[email value]];
                                    NSString *emailMD5 = [NSString hashedValue:[email value] uppercase:NO];
                                    [contactObject setEmailHash:emailMD5];
                                    [contactObject setContactID:emailMD5];
                                    totalContacts++;
                                    NCONLog(@"ContactModel : Name : EMAIL : %@ -- Phone: %@", contactObject.firstName, [email value]);
                                    NCONLog(@"ContactModel : Name : EMAIL : %@ -- Stripped Phone: %@", contactObject.lastName, emailMD5);
                                    NCONLog(@"ContactModel : Name : %@ %@ : totalContacts : %d", contactObject.firstName,contactObject.lastName, totalContacts);
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
                                            NCONLog(@"ContactModel : Name : EMAIL : contact Name -->'%@ %@' : updateContact = %@: updateDate = %@",[contact givenName],[contact familyName],updateContact?@"YES":@"NO",updateContactModificationDate?@"YES":@"NO");
                                            
                                            if(updateContact || updateContactModificationDate)
                                            {
                                                status = [self updateContact:contactObject];
                                                NCONLog(@"ContactModel : Name : EMAIL : UPDATE contact Name -->'%@ %@'",[contact givenName],[contact familyName]);
                                            }
                                            else
                                            {
                                                NCONLog(@"ContactModel : Name : EMAIL : DID NOT CHANGE -->'%@ %@'",[contact givenName],[contact familyName]);
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
                                                [[AppManager SQLDataAccess] ExecuteTransaction:contactsTransaction];
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
                        status = [[AppManager SQLDataAccess] ExecuteTransaction:contactsTransaction];
                        NCONLog(@"ContactModel : UPDATE contactsTransaction : status = %@ ",status?@"YES":@"NO");
                    }
                    
                    [SettingsModel setTotalUserContacts:[NSNumber numberWithInt:totalContacts]];
                    [SettingsModel setFinishDateTimeStamp:[AppManager UTCDateTime] forIndex:0];
                    NCONLog(@"ContactModel : Finished Insert [%ld] : time = %f",[contactsTransaction count],[SettingsModel getStartToFinishTimeForIndex:0]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Send a notification to the Contacts view to reload
                        [[NSNotificationCenter defaultCenter] postNotificationName:CONTACTS_UPDATE_NOTIFICATION object:nil];
                    });
                }
            }
         } // YES
    }];
    [SettingsModel setProcessingContacts:NO];
	return status;
}

@end
