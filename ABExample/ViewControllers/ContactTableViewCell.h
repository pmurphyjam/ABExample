//
//  ContactTableViewCell.h
//  ABExample
//
//  Created by Pat Murphy on 5/20/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Contact Table View Cell, just displays all the contact elements.
//  Uses a Nib for intial layout, dynamic layout takes place in cellForRow.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *firstName;
@property(nonatomic,strong) IBOutlet UILabel *lastName;
@property(nonatomic,strong) IBOutlet UILabel *emailAddress;
@property(nonatomic,strong) IBOutlet UILabel *phoneNumber;
@property(nonatomic,strong) IBOutlet UILabel *birthDate;
@property(nonatomic,strong) IBOutlet UILabel *company;
@property(nonatomic,strong) IBOutlet UILabel *address;
@property(nonatomic,strong) IBOutlet UILabel *city;
@property(nonatomic,strong) IBOutlet UILabel *state;
@property(nonatomic,strong) IBOutlet UIButton *userThumbnail;

@end
