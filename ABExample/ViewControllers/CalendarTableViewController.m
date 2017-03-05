//
//  CalendarTableViewController.m
//  ABExample
//
//  Created by Pat Murphy on 5/18/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CalendarTableViewController.h"
#import "CalendarTableViewCell.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "CalendarModel.h"
#import "CalendarObject.h"
#import "AppDebugLog.h"
#import "SettingsModel.h"
#import "AppDateFormatter.h"
#import "UIColor+Category.h"

@interface CalendarTableViewController ()

@property(nonatomic,strong) IBOutlet UITableView *calendarTable;
@property(nonatomic,strong) NSMutableArray *calendarArray;
@property(nonatomic,strong) NSMutableArray *sectionDetails;
@property(nonatomic,strong) NSMutableArray *calendarSearchArray;
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) NSIndexPath *indexPathToShowSelection;
@property(nonatomic,strong) NSString *currentSearchString;
@property(nonatomic,strong) AppDateFormatter *dateFormatter;
@property(nonatomic,strong) NSIndexPath *todaysIndexPath;
@property(nonatomic,assign) BOOL haveToday;

@end

@implementation CalendarTableViewController

@synthesize calendarTable;
@synthesize calendarArray;
@synthesize sectionDetails;
@synthesize calendarSearchArray;
@synthesize indexArray;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize indexPathToShowSelection;
@synthesize currentSearchString;
@synthesize dateFormatter;
@synthesize todaysIndexPath;
@synthesize haveToday;

#define DEBUG
#import "AppConstants.h"

#define LABEL_Y_INCR         21.0
#define ATTENDEE_OFFSET      56.0
#define ATTENDEE_OFFSET1     80.0
#define NOTES_OFFSET         56.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    NDLog(@"CalendarVCtrl: viewDidLoad ");
    [CalendarModel getCalendarAuthorization];

    dateFormatter = [[AppDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    todaysIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    calendarArray = [[NSMutableArray alloc] init];
    indexArray = [NSMutableArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
        
    [searchBar setPlaceholder:@"Search for Event Name or Location"];
    [[UITableView appearance] setSectionIndexBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"CalendarVCtrl"
                                            action:@"WillAppear"
                                             label:[SettingsModel getEmailAddress]
                                             value:nil] build];
    [[AppAnalytics sharedInstance].defaultTracker send:event];
    [[AppAnalytics sharedInstance].defaultTracker set:kGAIScreenName value:@"CalendarVCtrl"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCalendar) name:CALENDAR_UPDATE_NOTIFICATION object:nil];
    
    if([SettingsModel getLoginState])
    {
        //Do this so Contacts alert shows up on main thread
        dispatch_async(dispatch_get_main_queue(),^{
            BOOL calendarAccessGranted = [SettingsModel getCalendarAuthorization];
            BOOL updateCalendar = [CalendarModel updateCalendarRequired];
            NDLog(@"CalendarVCtrl : calendarAccessGranted = %@ : updateCalendar = %@",calendarAccessGranted?@"YES":@"NO",updateCalendar?@"YES":@"NO");
            
            if(updateCalendar && calendarAccessGranted && [SettingsModel getProcessingCalendarEvents] == NO)
            {
                //Goes through the users address book since there's been a contact change
                NDLog(@"CalendarVCtrl: viewWillAppear : getCalendarEvents ");
                [CalendarModel getCalendarEvents];
            }
        });
    }
    haveToday = NO;
    [self populateCalendar:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [searchDisplayController setActive:NO animated:NO];
    [searchBar resignFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CALENDAR_UPDATE_NOTIFICATION object:nil];
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
        [searchDisplayController.searchResultsTableView reloadData];
    else
        [calendarTable reloadData];
}

- (IBAction)todayButtonAction:(id)sender
{
    NDLog(@"CalendarVCtrl: todayButtonAction[%d:%d] ",todaysIndexPath.section,todaysIndexPath.row);
    if(haveToday)
        [calendarTable scrollToRowAtIndexPath:todaysIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)populateCalendar:(BOOL)reload
{
    calendarArray = [CalendarModel getCalendarForView];
    calendarSearchArray = [CalendarModel getCalendarForView];
    sectionDetails = [CalendarModel getCalendarSectionsForView];
    if(reload)
        [calendarTable reloadData];
    NDLog(@"CalendarVCtrl: calendarArray[%d] = %@",(int)[calendarArray count],calendarArray);
    NDLog(@"CalendarVCtrl: sectionDetails[%d] = %@",(int)[sectionDetails count],sectionDetails);
}

-(void)updateCalendar
{
    calendarArray = [CalendarModel getCalendarForView];
    calendarSearchArray = [CalendarModel getCalendarForView];
    sectionDetails = [CalendarModel getCalendarSectionsForView];
    [calendarTable reloadData];
    NDLog(@"CalendarVCtrl: calendarArray[%d] = %@",(int)[calendarArray count],calendarArray);
    NDLog(@"CalendarVCtrl: sectionDetails[%d] = %@",(int)[sectionDetails count],sectionDetails);
}

-(void)performSearchMatchingSearchText:(NSString*)searchText
{
    __block NSString *searchTextStr = searchText;
    NDLog(@"CalendarVCtrl : performSearchMatchingSearchText : searchTextStr = %@",searchTextStr);
    NSIndexSet *indexesOfItemsWithMatching = [calendarArray indexesOfObjectsPassingTest:^BOOL(CalendarObject *obj, NSUInteger idx, BOOL *stop)
                                              {
                                                  NSString *lastNameMatchingItems = [[obj eventTitle] lowercaseString];
                                                  NSRange lastNameRange = [lastNameMatchingItems rangeOfString:searchTextStr];
                                                  NSString *firstNameMatchingItems = [[obj eventLocation] lowercaseString];
                                                  NSRange firstNameRange = [firstNameMatchingItems rangeOfString:searchTextStr];
                                                  BOOL found = NO;
                                                  found = (lastNameRange.location != NSNotFound || firstNameRange.location != NSNotFound);
                                                  return found;
                                              }];
    
    if( [indexesOfItemsWithMatching count] > 0 )
    {
        NSArray *searchResultsArray = [NSArray arrayWithArray:[calendarArray objectsAtIndexes:indexesOfItemsWithMatching]];
        [calendarSearchArray setArray:searchResultsArray];
    }
    else
    {
        //Clear the search array if you have no matches otherwise the previous one will persist
        [calendarSearchArray setArray:[NSArray new]];
    }
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBarInst
{
    NDLog(@"CalendarVCtrl : searchBarCancelButtonClicked ");
    [searchBar setText:@""];
    [searchDisplayController setActive:NO animated:YES];
    [searchBar resignFirstResponder];
    calendarSearchArray = [CalendarModel getCalendarForView];
    [calendarTable reloadData];
    NDLog(@"CalendarVCtrl : searchBarCancelButtonClicked : searchBar = %@",NSStringFromCGRect(searchBar.frame));
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
    NDLog(@"CalendarVCtrl : searchBarTextDidEndEditing ");
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NDLog(@"CalendarVCtrl : searchBar : textDidChange");
    if ([searchText isEqualToString:@""])
    {
        [calendarTable reloadData];
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
    searchDisplayController.searchResultsTableView.frame = calendarTable.frame;
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
        [calendarTable selectRowAtIndexPath:indexPathToShowSelection animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        indexPathToShowSelection = nil;
    }
}

#pragma mark UITableView indexing

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        //If we're in search mode we have no IndexTitles
        return nil;
    }
    else if (tableView == calendarTable)
    {
        //To Turn indexing off for return nil here
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
    if (tableView == calendarTable)
        headerHeight = 28.0;
    else if (tableView == searchDisplayController.searchResultsTableView)
        //If we're in search mode we have no sectionHdrView
        headerHeight = 0.0;
    
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //This is the alpha date section header we return
    UIView *sectionHdrView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,28)];
    sectionHdrView.layer.cornerRadius = 14;
    sectionHdrView.layer.masksToBounds = YES;
    sectionHdrView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    if (tableView == calendarTable)
    {
        UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        NSString *sectionLabelStr = [NSString stringWithString:[[sectionDetails objectAtIndex:section] objectForKey:@"SectionHeader"]];
        NSString *sectionMonthAndDay = @"";
        NSString *monthAndDay = [AppManager getMediumDatefromDate:[NSDate date]];
        NSArray *sectionArray = [sectionLabelStr componentsSeparatedByString:@":"];
        if([sectionArray count] > 0)
            sectionMonthAndDay = [sectionArray objectAtIndex:0];
        
        if([sectionMonthAndDay isEqualToString:monthAndDay])
        {
            sectionLabelStr = @"Today";
            //For quick scrolling to today
            todaysIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            haveToday = YES;
        }
        else
            sectionLabelStr = [sectionLabelStr stringByReplacingOccurrencesOfString:@":" withString:@" "];
        
        
        NSAttributedString *sectionAttStr = [[NSAttributedString alloc] initWithString:sectionLabelStr
                                                                              attributes:@{NSFontAttributeName:labelFont}];
        CGRect rect = [sectionAttStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width,CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil];
        [label setFrame:CGRectMake(self.view.frame.size.width/2 - rect.size.width/2, 0, self.view.frame.size.width, 28)];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [sectionHdrView setBackgroundColor:[UIColor colorWithHexRGB:@"ededed" AndAlpha:1.0]];
        [label setFont:labelFont];
        [label setTextColor:[UIColor blackColor]];
        [sectionHdrView addSubview:label];
        [label setText:sectionLabelStr];
    }
    else if (tableView == searchDisplayController.searchResultsTableView)
    {
        //If we're in search mode we have no sectionHdrView
        sectionHdrView = nil;
        label = nil;
    }
    
    return sectionHdrView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        //If we're in search mode we have just one section
        return 1;
    }
    else if (tableView == calendarTable)
    {
        NSString * selectedIndex = [indexArray objectAtIndex:index];
        int sectionHeadersIndex = 0;
        NSString *monthStr = [[sectionDetails objectAtIndex:sectionHeadersIndex] objectForKey:@"SectionHeader"];
        monthStr = [monthStr substringWithRange:NSMakeRange(0, 3)];
        NSComparisonResult result = [selectedIndex compare:monthStr];
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
        NDLog(@"CalendarVCtrl : index = %d : sectionForIndex = %d : selectedIndex = %@",(int)index,sectionHeadersIndex,selectedIndex);
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

- (NSString*)getAllAttendees:(CalendarObject*)calendarObject
{
    NSMutableString *attendees = [[NSMutableString alloc] init];
    int index = 0;
    for (CalendarAttendeeObject *calendarAttendee in [calendarObject attendeesArray])
    {
        if(index == [[calendarObject attendeesArray] count] - 1)
            [attendees appendFormat:@"%@ %@",[calendarAttendee firstName],[calendarAttendee lastName]];
        else
            [attendees appendFormat:@"%@ %@, ",[calendarAttendee firstName],[calendarAttendee lastName]];
        index++;
    }
    return attendees;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    //If we're in search mode we have just one section
    if (tableView == searchDisplayController.searchResultsTableView)
        sections = 1;
    else if (tableView == calendarTable)
        sections =  [sectionDetails count];
    
    return sections;
}

-(int)getRowFromSectionDetails:(NSIndexPath*)indexPath
{
    //Get the row to the CalendarObject from the sectionsDetails
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
        sections = [calendarSearchArray count];
    }
    else if (tableView == calendarTable)
    {
        sections = [[[sectionDetails objectAtIndex:section] objectForKey:@"Rows"] intValue];
    }
    return sections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = 0;
    CalendarObject *calendarObject = nil;
    
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        calendarObject = [calendarSearchArray objectAtIndex:indexPath.row];
    }
    else if (tableView == calendarTable)
    {
        row = [self getRowFromSectionDetails:indexPath];
        calendarObject = [calendarArray objectAtIndex:row];
    }
    
    int numberOfItems = (int)[[calendarObject numberOfItems] integerValue];
    
    CGFloat height = 45.0;
    if(numberOfItems >= 2)
    {
        height = height + (numberOfItems - 2) * LABEL_Y_INCR;
        NSAttributedString *attendeesAttStr = [[NSAttributedString alloc] initWithString:[self getAllAttendees:calendarObject]
                                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGRect rect = [attendeesAttStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - ATTENDEE_OFFSET,CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                context:nil];
        height = height + rect.size.height;
        
        if([[calendarObject notes] length] > 0)
        {
            NSAttributedString *notesAttStr = [[NSAttributedString alloc] initWithString:[calendarObject notes]
                                                                              attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:16]}];
            CGRect rect = [notesAttStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - NOTES_OFFSET,CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            height = height + rect.size.height;
        }
        
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == calendarTable || tableView == searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"CalendarTableViewCell";
        CalendarTableViewCell *cell = (CalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            UINib* customCellNib = [UINib nibWithNibName:@"CalendarTableViewCell" bundle:nil];
            [tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
            cell = (CalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        int row = 0;
        CalendarObject *calendarObject = nil;
        
        if (tableView == searchDisplayController.searchResultsTableView)
        {
            calendarObject = [calendarSearchArray objectAtIndex:indexPath.row];
        }
        else if (tableView == calendarTable)
        {
            row = [self getRowFromSectionDetails:indexPath];
            calendarObject = [calendarArray objectAtIndex:row];
        }
        
        NDLog(@"CalendarVCtrl: cellForRow[%d] : contact = %@",(int)[indexPath row],calendarObject);
        //Layout the cells so they only appear if they have data for them
        CGRect labelRect = cell.eventTitle.frame;
        if([[calendarObject eventTitle] length] > 0)
        {
            [[cell eventTitle] setHidden:NO];
            [[cell eventTitle] setText:[calendarObject eventTitle]];
            labelRect = cell.eventTitle.frame;
            labelRect.origin.y = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell eventTitle] setHidden:YES];
        
        
        if([[calendarObject eventLocation] length] > 0)
        {
            [[cell eventLocation] setHidden:NO];
            cell.eventLocation.frame = labelRect;
            [[cell eventLocation] setText:[calendarObject eventLocation]];
            labelRect.origin.y  = labelRect.origin.y + LABEL_Y_INCR;
        }
        else
            [[cell eventLocation] setHidden:YES];
        
        //The notes label is dynamic dependent upon the size of the text in the note
        if([[calendarObject notes] length] > 0)
        {
            [[cell notes] setHidden:NO];
            [[cell notes] setText:[calendarObject notes]];
            NSAttributedString *notesAttStr = [[NSAttributedString alloc] initWithString:[calendarObject notes]
                                                                              attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:16]}];
            CGRect rect = [notesAttStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - NOTES_OFFSET,CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil];
            CGRect noteRect = cell.notes.frame;
            noteRect.origin.y = labelRect.origin.y;
            noteRect.size.height = rect.size.height;
            noteRect.size.width = rect.size.width;
            cell.notes.frame = noteRect;
            labelRect.origin.y  = labelRect.origin.y + rect.size.height;
            [[cell notes] setNumberOfLines:0];
            [[cell notes] setLineBreakMode:NSLineBreakByWordWrapping];
            [[cell notes] sizeToFit];
        }
        else
            [[cell notes] setHidden:YES];
        
        //The attendees label is dynmaic dependent upon the number of attendees and size of their names
        if([[calendarObject attendeesArray] count] > 0)
        {
            int numberOfItems = (int)[[calendarObject numberOfItems] integerValue];
            CGFloat attendee_offset = ATTENDEE_OFFSET;
            CGFloat x_offset = 10;
            if(numberOfItems <= 2)
            {
                attendee_offset = ATTENDEE_OFFSET1;
                x_offset = 60;
            }
            NSString *attendeesStr = [self getAllAttendees:calendarObject];
            NSAttributedString *attendeesAttStr = [[NSAttributedString alloc] initWithString:attendeesStr
                                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            CGRect rect = [attendeesAttStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - attendee_offset,CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil];
            CGRect attendeeRect = cell.attendees.frame;
            attendeeRect.origin.y = labelRect.origin.y;
            attendeeRect.origin.x = x_offset;
            attendeeRect.size.height = rect.size.height;
            attendeeRect.size.width = rect.size.width;
            cell.attendees.frame = attendeeRect;
            [[cell attendees] setText:attendeesStr];
            [[cell attendees] setNumberOfLines:0];
            [[cell attendees] setLineBreakMode:NSLineBreakByWordWrapping];
            [[cell attendees] sizeToFit];
        }

        NSDate *startDate = [AppManager getDateFromDateString:[calendarObject startDate]];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        if([startDateStr length] > 0)
        {
            NSArray *startDateArray = [startDateStr componentsSeparatedByString:@" "];
            if([startDateArray count] > 0)
            {
                NSString *time = [startDateArray objectAtIndex:0];
                NSString *timeIndicator = [startDateArray objectAtIndex:1];
                [[cell time] setText:time];
                [[cell timeIndicator] setText:timeIndicator];
            }
        }
        
        return cell;
    }
    return nil;
}

//Keep this last in the file
- (void)didReceiveMemoryWarning
{
    [AppManager currentMemoryConsumption:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]];
    [[AppDebugLog appDebug] writeDebugData:[NSString stringWithFormat:@"CalendarVCtrl: didReceiveMemoryWarning"]];
    NSLog(@"CalendarVCtrl: didReceiveMemoryWarning : ERROR");
    [super didReceiveMemoryWarning];
}


@end
