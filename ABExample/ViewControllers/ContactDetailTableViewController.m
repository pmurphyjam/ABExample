//
//  ContactDetailTableViewController.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "ContactDetailTableViewController.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"
#import "ContactModel.h"

@interface ContactDetailTableViewController ()

@end

@implementation ContactDetailTableViewController

@synthesize delegate,firstNameTextField,lasttNameTextField,addressTextField,emailAddressTextField,phoneNumberTextField,cityTextField,stateTextField,companyTextField,birthDateTextField,contactToEdit;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [[AppAnalytics sharedInstance].defaultTracker set:kGAIScreenName value:@"AddContactVCtrl"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(IBAction)save:(id)sender
{
    if(contactToEdit != nil)
    {
        int numberOfItems = 2;
        contactToEdit.firstName = firstNameTextField.text;
        contactToEdit.lastName = lasttNameTextField.text;
        contactToEdit.address = addressTextField.text;
        contactToEdit.emailAddress = emailAddressTextField.text;
        contactToEdit.phoneNumber = phoneNumberTextField.text;
        contactToEdit.city = cityTextField.text;
        contactToEdit.state = stateTextField.text;
        contactToEdit.company = companyTextField.text;
        contactToEdit.birthDate = birthDateTextField.text;
        
        [contactToEdit setNameHash:[ContactModel getMD5HashedValue:[NSString stringWithFormat:@"%@%@",[contactToEdit firstName],[contactToEdit lastName]]]];
        
        if([[contactToEdit address] length] > 0)
            numberOfItems++;
        
        if([[contactToEdit city] length] > 0)
            numberOfItems++;
        
        if([[contactToEdit state] length] > 0)
            numberOfItems++;
        
        if([[contactToEdit emailAddress] length] > 0)
        {
            numberOfItems++;
            NSString *emailMD5 = [ContactModel getMD5HashedValue:[contactToEdit emailAddress]];
            [contactToEdit setEmailHash:emailMD5];
            [contactToEdit setContactID:emailMD5];
        }
        
        if([[contactToEdit phoneNumber] length] > 0)
        {
            numberOfItems++;
            NSString *phoneMD5 = [ContactModel getMD5HashedValue:[contactToEdit phoneNumber]];
            [contactToEdit setPhoneHash:phoneMD5];
            [contactToEdit setContactID:phoneMD5];
        }
        
        if([[contactToEdit company] length] > 0)
            numberOfItems++;
        
        if([[contactToEdit birthDate] length] > 0)
            numberOfItems++;
        
        [contactToEdit setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
        
        [contactToEdit setModificationDate:[AppManager UTCDateTime]];
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
        int numberOfItems = 2;
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
        
        [contact setNameHash:[ContactModel getMD5HashedValue:[NSString stringWithFormat:@"%@%@",[contact firstName],[contact lastName]]]];

        if([[contact address] length] > 0)
            numberOfItems++;
        
        if([[contact city] length] > 0)
            numberOfItems++;
        
        if([[contact state] length] > 0)
            numberOfItems++;
        
        if([[contact emailAddress] length] > 0)
        {
            numberOfItems++;
            NSString *emailMD5 = [ContactModel getMD5HashedValue:[contact emailAddress]];
            [contact setEmailHash:emailMD5];
            [contact setContactID:emailMD5];
        }
        
        if([[contact phoneNumber] length] > 0)
        {
            numberOfItems++;
            NSString *phoneMD5 = [ContactModel getMD5HashedValue:[contact phoneNumber]];
            [contact setPhoneHash:phoneMD5];
            [contact setContactID:phoneMD5];
        }
        
        if([[contact company] length] > 0)
            numberOfItems++;
        
        if([[contact birthDate] length] > 0)
            numberOfItems++;
        
        [contact setNumberOfItems:[NSNumber numberWithInt:numberOfItems]];
        [contact setModificationDate:[AppManager UTCDateTime]];

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
    if(([contact.firstName length] == 0) || ([contact.lastName length] == 0))
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
    [[AppDebugLog appDebug] writeDebugData:[NSString stringWithFormat:@"ContactDetailVCtrl : didReceiveMemoryWarning"]];
    NSLog(@"ContactDetailVCtrl : didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}
@end
