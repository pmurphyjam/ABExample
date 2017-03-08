//
//  ContactTableViewCell.m
//  ABExample
//
//  Created by Pat Murphy on 5/20/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

@synthesize firstName;
@synthesize lastName;
@synthesize emailAddress;
@synthesize phoneNumber;
@synthesize birthDate;
@synthesize company;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize userThumbnail;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
