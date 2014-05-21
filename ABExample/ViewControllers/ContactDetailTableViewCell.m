//
//  ContactDetailTableViewCell.m
//  ABExample
//
//  Created by Pat Murphy on 5/20/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import "ContactDetailTableViewCell.h"

@implementation ContactDetailTableViewCell

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
