//
//  ContactsTableViewController.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactTableViewCell.h"
#import "ContactDetailTableViewController.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "ContactModel.h"
#import "ContactObject.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"

@interface ContactsTableViewController ()

@property (nonatomic,strong) NSMutableArray *contactArray;
@property(nonatomic,strong) IBOutlet UITableView *contactsTable;

@end


@implementation ContactsTableViewController

@synthesize contactsTable;
@synthesize contactArray;

#define DEBUG
#import "AppConstants.h"

- (void)viewDidLoad
{
    [super viewDidLoad];
    NDLog(@"ContactsVCtrl: viewDidLoad ");
    contactArray= [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"ContactsVCtrl"
                                            action:@"WillAppear"
                                             label:[SettingsModel getUserName]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];
    
    [self populateContacts:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)populateContacts:(BOOL)reload
{
    contactArray= [ContactModel getContactsForView];
    if(reload)
        [contactsTable reloadData];
    NDLog(@"ContactsVCtrl: contactArray[%d] = %@",[contactArray count],contactArray);
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddContact"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        ContactDetailTableViewController *contactDetailTableViewController = [[navigationController viewControllers] objectAtIndex:0];
        [contactDetailTableViewController setDelegate:(id)self];
    }
    else if([segue.identifier isEqualToString:@"EditContact"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        ContactDetailTableViewController *contactDetailTableViewController = [[navigationController viewControllers] objectAtIndex:0];
        [contactDetailTableViewController setDelegate:(id)self];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ContactObject *contact = [contactArray objectAtIndex:[indexPath row]];
        contactDetailTableViewController.contactToEdit = contact;
    }
}

#pragma mark - addContact Delegates

-(void) addContactViewControllerDidCancel:(ContactDetailTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [contactsTable reloadData];
}

-(void) addContactViewController:(ContactDetailTableViewController *)controller didEditContact:(ContactObject*)contact
{
    [ContactModel updateContact:contact];
    [self populateContacts:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) addContactViewController:(ContactDetailTableViewController *)controller didAddContact:(ContactObject*)contact
{
    [ContactModel insertContact:contact];
    [self populateContacts:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"EditContact" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 221.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contactsTable)
    {
        static NSString *CellIdentifier = @"ContactTableViewCell";
        ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            UINib* customCellNib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:nil];
            [tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
            cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        ContactObject *contactObject = [contactArray objectAtIndex:[indexPath row]];
        NDLog(@"ContactsVCtrl: cellForRow[%d] : contact = %@",[indexPath row],contactObject);

        [[cell firstName] setText:[contactObject firstName]];
        [[cell lastName] setText:[contactObject lastName]];
        [[cell address] setText:[contactObject address]];
        [[cell city] setText:[contactObject city]];
        [[cell state] setText:[contactObject state]];
        [[cell phoneNumber] setText:[contactObject phoneNumber]];
        [[cell emailAddress] setText:[contactObject emailAddress]];
        [[cell company] setText:[contactObject company]];
        [[cell birthDate] setText:[contactObject birthDate]];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contactsTable)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            ContactObject *contact = [contactArray objectAtIndex:[indexPath row]];
            NDLog(@"ContactsVCtrl: Delete : contact[%ld] = %@",(long)[indexPath row],contact);
            [ContactModel deleteContact:contact];
            [self populateContacts:NO];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

//Keep this last in the file
- (void)didReceiveMemoryWarning
{
    [AppManager currentMemoryConsumption:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]];
    [AppDebugLog writeDebugData:[NSString stringWithFormat:@"ContactsVCtrl: didReceiveMemoryWarning"]];
    NSLog(@"ContactsVCtrl: didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}
@end
