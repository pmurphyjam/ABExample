//
//  AppDateFormatter.m
//  AppIOS
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "AppDateFormatter.h"

@implementation AppDateFormatter

- (id)init
{
	if ((self = [super init]))
	{
        [self setLocale:[NSLocale autoupdatingCurrentLocale]];
	}
	
	return self;
}

@end
