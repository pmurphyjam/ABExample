//
//  ContactDetailTableViewController.h
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "ContactObject.h"


@class ContactDetailTableViewController;

@protocol AddContactDelegate<NSObject>

-(void) addContactViewController:(ContactDetailTableViewController*)controller didAddContact:(ContactObject*)contact;
-(void) addContactViewController:(ContactDetailTableViewController*)controller didEditContact:(ContactObject*)contact;
-(void) addContactViewControllerDidCancel:(ContactDetailTableViewController*)controller;

@end

@interface ContactDetailTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic,strong) ContactObject *contactToEdit;
@property (nonatomic,strong) IBOutlet UITextField *firstNameTextField;
@property (nonatomic,strong) IBOutlet UITextField *lasttNameTextField;
@property (nonatomic,strong) IBOutlet UITextField *addressTextField;
@property (nonatomic,strong) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic,strong) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic,strong) IBOutlet UITextField *cityTextField;
@property (nonatomic,strong) IBOutlet UITextField *stateTextField;
@property (nonatomic,strong) IBOutlet UITextField *companyTextField;
@property (nonatomic,strong) IBOutlet UITextField *birthDateTextField;
@property (nonatomic,weak) id<AddContactDelegate> delegate;

-(IBAction)save:(id) sender;
-(IBAction)cancel:(id) sender;
-(BOOL)validate:(ContactObject*)contact;

@end
