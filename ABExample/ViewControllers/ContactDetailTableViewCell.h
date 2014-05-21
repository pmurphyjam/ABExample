//
//  ContactDetailTableViewCell.h
//  ABExample
//
//  Created by Pat Murphy on 5/20/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UITextField *firstName;
@property(nonatomic,strong) IBOutlet UITextField *lastName;
@property(nonatomic,strong) IBOutlet UITextField *emailAddress;
@property(nonatomic,strong) IBOutlet UITextField *phoneNumber;
@property(nonatomic,strong) IBOutlet UITextField *birthDate;
@property(nonatomic,strong) IBOutlet UITextField *company;
@property(nonatomic,strong) IBOutlet UITextField *address;
@property(nonatomic,strong) IBOutlet UITextField *city;
@property(nonatomic,strong) IBOutlet UITextField *state;
@property(nonatomic,strong) IBOutlet UIButton *userThumbnail;

@end
