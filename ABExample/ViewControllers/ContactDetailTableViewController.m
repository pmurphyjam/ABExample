//
//  ContactDetailTableViewController.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import "ContactDetailTableViewController.h"
#import "ContactDetailTableViewCell.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"

@interface ContactDetailTableViewController ()

@property (nonatomic,strong) NSMutableDictionary *contactImages;

@end

@implementation ContactDetailTableViewController

@synthesize delegate,firstNameTextField,lasttNameTextField,addressTextField,emailAddressTextField,phoneNumberTextField,cityTextField,stateTextField,companyTextField,birthDateTextField,contactToEdit,contactImages;

- (void)viewDidLoad
{
    [super viewDidLoad];
    contactImages = [[NSMutableDictionary alloc] init];
    [firstNameTextField setDelegate:self];
    [lasttNameTextField setDelegate:self];
    [addressTextField setDelegate:self];
    [emailAddressTextField setDelegate:self];
    [phoneNumberTextField setDelegate:self];
    [cityTextField setDelegate:self];
    [stateTextField setDelegate:self];
    [companyTextField setDelegate:self];
    [birthDateTextField setDelegate:self];

    if(contactToEdit != nil)
    {
        self.title = [NSString stringWithFormat:@"%@ %@",contactToEdit.firstName,contactToEdit.lastName];
        firstNameTextField.text = contactToEdit.firstName;
        lasttNameTextField.text = contactToEdit.lastName;
        addressTextField.text = contactToEdit.address;
        emailAddressTextField.text = contactToEdit.emailAddress;
        phoneNumberTextField.text = contactToEdit.phoneNumber;
        cityTextField.text = contactToEdit.city;
        stateTextField.text = contactToEdit.state;
        companyTextField.text = contactToEdit.company;
        birthDateTextField.text = contactToEdit.birthDate;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"AddContactVCtrl"
                                            action:@"WillAppear"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(NSString*)getRandomCompanyLogo
{
    //These PNG's are in the Companies folder
    //There never displayed, but it shows how to store an image in the DB
    NSString *companyLogo = @"Apple.png";
    int logoInt = (int)arc4random() % 8;
    if(logoInt == 0)
        companyLogo = @"Apple.png";
    else if (logoInt == 1)
        companyLogo = @"AMD.png";
    else if (logoInt == 2)
        companyLogo = @"Intel.png";
    else if (logoInt == 3)
        companyLogo = @"Cisco.png";
    else if (logoInt == 4)
        companyLogo = @"ChaseBank.png";
    else if (logoInt == 5)
        companyLogo = @"Chevron.png";
    else if (logoInt == 6)
        companyLogo = @"BofA.png";
    else if (logoInt == 7)
        companyLogo = @"WellsFargo.png";
    else if (logoInt == 8)
        companyLogo = @"Zynga.png";
    else
        companyLogo = @"Apple.png";
    
    return companyLogo;
}

-(IBAction)save:(id)sender
{
    if(contactToEdit != nil)
    {
        contactToEdit.firstName = firstNameTextField.text;
        contactToEdit.lastName = lasttNameTextField.text;
        contactToEdit.address = addressTextField.text;
        contactToEdit.emailAddress = emailAddressTextField.text;
        contactToEdit.phoneNumber = phoneNumberTextField.text;
        contactToEdit.city = cityTextField.text;
        contactToEdit.state = stateTextField.text;
        contactToEdit.company = companyTextField.text;
        contactToEdit.birthDate = birthDateTextField.text;
        [contactToEdit setUserThumbnail:UIImagePNGRepresentation([UIImage imageNamed:[self getRandomCompanyLogo]])];
        
        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"ContactDetailVCtrl"
                                                action:@"EditExistingContact"
                                                 label:[SettingsModel getUserName]
                                                 value:nil] build];
        [[AppAnalytics sharedInstance].defaultTracker send:event];
        
        if(![self validate:contactToEdit])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Contact" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }
        [delegate addContactViewController:self didEditContact:contactToEdit];
    }
    else
    {
        ContactObject *contact = [[ContactObject alloc] init];
        contact.firstName = firstNameTextField.text;
        contact.lastName = lasttNameTextField.text;
        contact.address = addressTextField.text;
        contact.emailAddress = emailAddressTextField.text;
        contact.phoneNumber = phoneNumberTextField.text;
        contact.city = cityTextField.text;
        contact.state = stateTextField.text;
        contact.company = companyTextField.text;
        contact.birthDate = birthDateTextField.text;
        [contactToEdit setUserThumbnail:UIImagePNGRepresentation([UIImage imageNamed:[self getRandomCompanyLogo]])];
        
        NSMutableDictionary *event =
        [[GAIDictionaryBuilder createEventWithCategory:@"ContactDetailVCtrl"
                                                action:@"AddNewContact"
                                                 label:[SettingsModel getUserName]
                                                 value:nil] build];
        [[AppAnalytics sharedInstance].defaultTracker send:event];
        
        if(![self validate:contact])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Contact" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }
        [delegate addContactViewController:self didAddContact:contact];
    }
}

-(BOOL)validate:(ContactObject*)contact
{
    //Should really check all the fields, but hey it's a demo
    if(([contact.firstName length] == 0) || ([contact.address length] == 0))
    {
        return NO;
    }
    
    return YES;
}

-(IBAction)cancel:(id)sender
{
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"ContactDetailVCtrl"
                                            action:@"CancelContact"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];
    
    [delegate addContactViewControllerDidCancel:self];
}

//Keep this last in the file
- (void)didReceiveMemoryWarning
{
    [AppManager currentMemoryConsumption:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]];
    [AppDebugLog writeDebugData:[NSString stringWithFormat:@"ContactDetailVCtrl : didReceiveMemoryWarning"]];
    NSLog(@"ContactDetailVCtrl : didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}
@end
