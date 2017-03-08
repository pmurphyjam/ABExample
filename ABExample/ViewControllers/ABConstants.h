//
//  ABConstants.h
//  ABExample
//
//  Created by Pat Murphy on 3/8/17.
//  Copyright © 2017 Pat Murphy. All rights reserved.
//

#define CONTACT_IMAGE_SIZE            CGSizeMake(120,120)

//Notifications
#define CONTACTS_UPDATE_NOTIFICATION    @"ContactsUpdateNotification"
#define CALENDAR_UPDATE_NOTIFICATION    @"CalendarUpdateNotification"

//#define DEBUG
#ifdef DEBUG
#    define NDLog(...) NSLog(__VA_ARGS__)
#else
#    define NDLog(...)
#endif

//#define DEBUGCON
#ifdef DEBUGCON
#    define NCONLog(...) NSLog(__VA_ARGS__)
#else
#    define NCONLog(...)
#endif

//#define DEBUGCR
#ifdef DEBUGCR
#    define NCRLog(...) NSLog(__VA_ARGS__)
#else
#    define NCRLog(...)
#endif

//#define DEBUGCAL
#ifdef DEBUGCAL
#    define NCALLog(...) NSLog(__VA_ARGS__)
#else
#    define NCALLog(...)
#endif


