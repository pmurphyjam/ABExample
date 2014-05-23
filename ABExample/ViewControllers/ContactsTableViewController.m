//
//  ContactsTableViewController.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
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
#import "ABContactsHelper.h"

@interface ContactsTableViewController ()

@property(nonatomic,strong) IBOutlet UITableView *contactsTable;
@property(nonatomic,strong) NSMutableArray *contactArray;
@property(nonatomic,strong) NSMutableArray *sectionDetails;
@property(nonatomic,strong) NSMutableArray *contactSearchArray;
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) NSIndexPath *indexPathToShowSelection;
@property(nonatomic,strong) NSString *currentSearchString;

@end

@implementation ContactsTableViewController

@synthesize contactsTable;
@synthesize contactArray;
@synthesize sectionDetails;
@synthesize contactSearchArray;
@synthesize indexArray;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize indexPathToShowSelection;
@synthesize currentSearchString;

//#define DEBUG
#import "AppConstants.h"

#define LABEL_Y_INCR         21.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    NDLog(@"ContactsVCtrl: viewDidLoad ");
    contactArray = [[NSMutableArray alloc] init];
    indexArray = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    [searchBar setPlaceholder:@"Search for a Contact"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContacts) name:CONTACTS_UPDATE_NOTIFICATION object:nil];
    
    if([SettingsModel getLoginState])
    {
        BOOL contactAccessGranted = [ABContactsHelper getAccessToContacts];
        BOOL updateContacts = [ContactModel updateContactsRequired];
        [SettingsModel setProcessingContacts:NO];
        NDLog(@"ContactsVCtrl : contactAccessGranted = %@ : updateContacts = %@",contactAccessGranted?@"YES":@"NO",updateContacts?@"YES":@"NO");
        
        if(updateContacts && contactAccessGranted && [SettingsModel getProcessingContacts] == NO)
        {
            //Goes through the users address book since there's been a contact change
            [ContactModel getUserContactsFromAddressBook];
        }
    }
    
    [self populateContacts:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [searchDisplayController setActive:NO animated:NO];
    [searchBar resignFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONTACTS_UPDATE_NOTIFICATION object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //Headers and search bars need to be reloaded on a view rotation
    if (searchDisplayController.active)
    {
        [searchDisplayController.searchResultsTableView reloadData];
    }
    else
        [contactsTable reloadData];
}

-(void)populateContacts:(BOOL)reload
{
    contactArray = [ContactModel getContactsForView];
    contactSearchArray = [ContactModel getContactsForView];
    sectionDetails = [ContactModel getContactsSectionsForView];
    if(reload)
        [contactsTable reloadData];
    NDLog(@"ContactsVCtrl: contactArray[%d] = %@",(int)[contactArray count],contactArray);
}

-(void)updateContacts
{
    contactArray = [ContactModel getContactsForView];
    contactSearchArray = [ContactModel getContactsForView];
    sectionDetails = [ContactModel getContactsSectionsForView];
    [contactsTable reloadData];
    NDLog(@"ContactsVCtrl: contactArray[%d] = %@",(int)[contactArray count],contactArray);
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
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        ContactObject *contact = [contactArray objectAtIndex:[indexPath row]];
        NDLog(@"ContactsVCtrl: cellForRow[%d] : Segue : Edit : contact = %@ : sender = %@",(int)[indexPath row],contact,sender);
        contactDetailTableViewController.contactToEdit = contact;
    }
}

-(void)performSearchMatchingSearchText:(NSString*)searchText
{
    __block NSString *firstName = @"";
    __block NSString *lastName = @"";
    __block BOOL twoNames = NO;
    //Need to search for first and last names, and get rid of white space characters.
    //If we have first and last, then use AND else use OR since it could be a first or a last name
    NSArray *nameArray = [searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NDLog(@"ContactsVCtrl : performSearchMatchingSearchText :  nameArray[%d] = %@",(int)[nameArray count],nameArray);
    if([nameArray count] > 0)
    {
        firstName = [nameArray objectAtIndex:0];
        lastName = [nameArray objectAtIndex:0];
        if([nameArray count] > 1)
        {
            lastName = [nameArray objectAtIndex:1];
            if([lastName length] > 0)
                twoNames = YES;
        }
    }
    NDLog(@"ContactsVCtrl : performSearchMatchingSearchText : firstName = %@ : lastName = %@ : twoNames = %@",firstName,lastName,twoNames?@"YES":@"NO");
    NSIndexSet *indexesOfItemsWithMatching = [contactArray indexesOfObjectsPassingTest:^BOOL(ContactObject *obj, NSUInteger idx, BOOL *stop)
                                              {
                                                  NSString *lastNameMatchingItems = [[obj lastName] lowercaseString];
                                                  NSRange lastNameRange = [lastNameMatchingItems rangeOfString:lastName];
                                                  NSString *firstNameMatchingItems = [[obj firstName] lowercaseString];
                                                  NSRange firstNameRange = [firstNameMatchingItems rangeOfString:firstName];
                                                  BOOL found = NO;
                                                  if(twoNames)
                                                      found = (lastNameRange.location != NSNotFound && firstNameRange.location != NSNotFound);
                                                  else
                                                      found = (lastNameRange.location != NSNotFound || firstNameRange.location != NSNotFound);
                                                  return found;
                                              }];
    
    if( [indexesOfItemsWithMatching count] > 0 )
    {
        NSArray *searchResultsArray = [NSArray arrayWithArray:[contactArray objectsAtIndexes:indexesOfItemsWithMatching]];
        [contactSearchArray setArray:searchResultsArray];
    }
    else
    {
        //Clear the search array if you have no matches otherwise the previous one will persist
        [contactSearchArray setArray:[NSArray new]];
    }
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBarInst
{
    NDLog(@"ContactsVCtrl : searchBarCancelButtonClicked ");
    [searchBar setText:@""];
    [searchDisplayController setActive:NO animated:YES];
    [searchBar resignFirstResponder];
    contactSearchArray = [ContactModel getContactsForView];
    [contactsTable reloadData];
    NDLog(@"ContactsVCtrl : searchBarCancelButtonClicked : searchBar = %@",NSStringFromCGRect(searchBar.frame));
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)aSearchBar
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    NDLog(@"ContactsVCtrl : searchBarTextDidEndEditing ");
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NDLog(@"ContactsVCtrl : searchBar : textDidChange");
    if ([searchText isEqualToString:@""])
    {
        [contactsTable reloadData];
    }
    
    [self setCurrentSearchString:[searchText lowercaseString]];
    [self performSearchMatchingSearchText:currentSearchString];
    [searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarInst
{
    [self performSelector:@selector(didRotateFromInterfaceOrientation:) withObject:nil afterDelay:0.0];
}

#pragma mark UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    searchDisplayController.searchResultsTableView.frame = contactsTable.frame;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    if( indexPathToShowSelection != nil )
    {
        [contactsTable selectRowAtIndexPath:indexPathToShowSelection animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        indexPathToShowSelection = nil;
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

#pragma mark UITableView indexing

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        //If we're in search mode we have no IndexTitles
        return nil;
    }
    else if (tableView == contactsTable)
    {
        return indexArray;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 28.0;
    if (tableView == contactsTable)
        headerHeight = 28.0;
    else if (tableView == searchDisplayController.searchResultsTableView)
        //If we're in search mode we have no sectionHdrView
        headerHeight = 0.0;

    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //This is the alpha section header we return
    UIView *sectionHdrView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,28)];
    sectionHdrView.layer.cornerRadius = 14;
    sectionHdrView.layer.masksToBounds = YES;
    sectionHdrView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 22, 0, self.view.frame.size.width, 28)];
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sectionHdrView setBackgroundColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [label setTextColor:[UIColor blackColor]];
    [sectionHdrView addSubview:label];
    
    if (tableView == contactsTable)
    {
        [label setText:[NSString stringWithString:[[sectionDetails objectAtIndex:section] objectForKey:@"SectionHeader"]]];
    }
    else if (tableView == searchDisplayController.searchResultsTableView)
        //If we're in search mode we have no sectionHdrView
        sectionHdrView = nil;
    
    return sectionHdrView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        //If we're in search mode we have just one section
        return 1;
    }
    else if (tableView == contactsTable)
    {
        NSString * selectedIndex = [indexArray objectAtIndex:index];
        int sectionHeadersIndex = 0;
        NSComparisonResult result = [selectedIndex compare:[[sectionDetails objectAtIndex:sectionHeadersIndex] objectForKey:@"SectionHeader"]];
        if (result == NSOrderedSame)
        {
            return sectionHeadersIndex;
        }
        else
        {
            while (result == NSOrderedDescending)
            {
                ++sectionHeadersIndex;
                if (sectionHeadersIndex == [sectionDetails count])
                {
                    return --sectionHeadersIndex;
                }
                result = [selectedIndex compare:[[sectionDetails objectAtIndex:sectionHeadersIndex] objectForKey:@"SectionHeader"]];
            }
        }
        NDLog(@"ContactsVCtrl : index = %d : sectionForIndex = %d : selectedIndex = %@",(int)index,sectionHeadersIndex,selectedIndex);
        return sectionHeadersIndex;
    }
    else
        return 0;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    //If we're in search mode we have just one section
    if (tableView == searchDisplayController.searchResultsTableView)
        sections = 1;
    else if (tableView == contactsTable)
        sections =  [sectionDetails count];
    
    return sections;
}

-(int)getRowFromSectionDetails:(NSIndexPath*)indexPath
{
    //Get the row to the ContactObject from the sectionsDetails where the number of alpha Contacts has a Rows number
    int row = 0;
    for (int index = 0; index < indexPath.section; index++)
    {
        row += [[[sectionDetails objectAtIndex:index] objectForKey:@"Rows"] intValue];
    }
    row += indexPath.row;
    return row;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sections = 0;
    if (tableView == searchDisplayController.searchResultsTableView )
    {
        sections = [contactSearchArray count];
    }
    else if (tableView == contactsTable)
    {
        sections = [[[sectionDetails objectAtIndex:section] objectForKey:@"Rows"] intValue];
    }
    return sections;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = 0;
    if (tableView == searchDisplayController.searchResultsTableView)
        [self performSegueWithIdentifier:@"EditContact" sender:indexPath];
    else if (tableView == contactsTable)
    {
        row = [self getRowFromSectionDetails:indexPath];
        NSIndexPath *indexPathSection = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        [self performSegueWithIdentifier:@"EditContact" sender:indexPathSection];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = 0;
    ContactObject *contactObject = nil;
    
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        contactObject = [contactSearchArray objectAtIndex:indexPath.row];
    }
    else if (tableView == contactsTable)
    {
        row = [self getRowFromSectionDetails:indexPath];
        contactObject = [contactArray objectAtIndex:row];
    }

    int numberOfItems = (int)[[contactObject numberOfItems] integerValue];
    CGFloat height = 85.0;
    if(numberOfItems > 3)
        height = height + (numberOfItems - 3) * LABEL_Y_INCR;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contactsTable || tableView == searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"ContactTableViewCell";
        ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            UINib* customCellNib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:nil];
            [tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
            cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        int row = 0;
        ContactObject *contactObject = nil;
        
        if (tableView == searchDisplayController.searchResultsTableView)
        {
            contactObject = [contactSearchArray objectAtIndex:indexPath.row];
        }
        else if (tableView == contactsTable)
        {
            row = [self getRowFromSectionDetails:indexPath];
            contactObject = [contactArray objectAtIndex:row];
        }

        NDLog(@"ContactsVCtrl: cellForRow[%d] : contact = %@",(int)[indexPath row],contactObject);
        //Move the first / last name labels if they have no photo
        if([[contactObject userThumbnail] length] > 10)
        {
            CGRect labelRect = cell.firstName.frame;
            labelRect.origin.x  = 65;
            cell.firstName.frame = labelRect;
            labelRect = cell.lastName.frame;
            labelRect.origin.x  = 65;
            cell.lastName.frame = labelRect;
            [[cell firstName] setText:[contactObject firstName]];
            [[cell lastName] setText:[contactObject lastName]];
            [[cell userThumbnail] setHidden:NO];
        }
        else
        {
            CGRect labelRect = cell.firstName.frame;
            labelRect.origin.x  = 20;
            cell.firstName.frame = labelRect;
            labelRect = cell.lastName.frame;
            labelRect.origin.x  = 20;
            cell.lastName.frame = labelRect;
            [[cell firstName] setText:[contactObject firstName]];
            [[cell lastName] setText:[contactObject lastName]];
            [[cell userThumbnail] setHidden:YES];
        }
        
        //Layout the cells so they only appear if they have data for them
        CGRect labelRect = cell.address.frame;
        if([[contactObject address] length] > 0)
        {
            [[cell address] setHidden:NO];
            [[cell address] setText:[contactObject address]];
            labelRect = cell.address.frame;
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell address] setHidden:YES];
        
        
        if([[contactObject city] length] > 0)
        {
            [[cell city] setHidden:NO];
            cell.city.frame = labelRect;
            [[cell city] setText:[contactObject city]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell city] setHidden:YES];

        if([[contactObject state] length] > 0)
        {
            [[cell state] setHidden:NO];
            cell.state.frame = labelRect;
            [[cell state] setText:[contactObject state]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell state] setHidden:YES];
        
        if([[contactObject phoneNumber] length] > 0)
        {
            [[cell phoneNumber] setHidden:NO];
            cell.phoneNumber.frame = labelRect;
            [[cell phoneNumber] setText:[contactObject phoneNumber]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell phoneNumber] setHidden:YES];

        
        if([[contactObject emailAddress] length] > 0)
        {
            [[cell emailAddress] setHidden:NO];
            cell.emailAddress.frame = labelRect;
            [[cell emailAddress] setText:[contactObject emailAddress]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell emailAddress] setHidden:YES];

        
        if([[contactObject company] length] > 0)
        {
            [[cell company] setHidden:NO];
            cell.company.frame = labelRect;
            [[cell company] setText:[contactObject company]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell company] setHidden:YES];

        
        if([[contactObject birthDate] length] > 0)
        {
            [[cell birthDate] setHidden:NO];
            cell.birthDate.frame = labelRect;
            [[cell birthDate] setText:[contactObject birthDate]];
        }
        else
            [[cell birthDate] setHidden:YES];
        
        [[cell userThumbnail] setImage:[UIImage imageWithData:[contactObject userThumbnail]] forState:UIControlStateNormal];
        [cell.userThumbnail.layer setCornerRadius:cell.userThumbnail.frame.size.width / 2];
        [cell.userThumbnail setClipsToBounds:YES];
        [cell.userThumbnail setHidden:NO];

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
            int row = 0;
            ContactObject *contactObject = nil;
            
            if (tableView == searchDisplayController.searchResultsTableView)
            {
                contactObject = [contactSearchArray objectAtIndex:indexPath.row];
            }
            else if (tableView == contactsTable)
            {
                row = [self getRowFromSectionDetails:indexPath];
                contactObject = [contactArray objectAtIndex:row];
            }
            NDLog(@"ContactsVCtrl: Delete : contact[%d] = %@",(int)[indexPath row],contactObject);
            [ContactModel deleteContact:contactObject];
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
