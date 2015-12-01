/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Person.h"
#import "Utility.h"

@interface TestBedViewController : UITableViewController <UISearchBarDelegate>
{
    CoreDataHelper *dataHelper;
    UISearchDisplayController *searchController;
}
@end

@implementation TestBedViewController

#pragma mark Data Source

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return dataHelper.fetchedResultsController.sections.count;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = dataHelper.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

// Return the title for a given section
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles = [dataHelper.fetchedResultsController sectionIndexTitles];
    if (titles.count <= section)
        return @"Error";
    return titles[section];
}

// Allow scrolling to search bar
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	// Query the titles for the section associated with an index title
	if (title == UITableViewIndexSearch)
	{
		[self.tableView scrollRectToVisible:searchController.searchBar.frame animated:NO];
		return -1;
	}
	return [dataHelper.fetchedResultsController.sectionIndexTitles indexOfObject:title];
}

// Section index titles
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if (aTableView == searchController.searchResultsTableView) return nil;
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[dataHelper.fetchedResultsController sectionIndexTitles]];
}

// Return a table-specific cell and populate it with the data at the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	Person *person = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.fullname;    
	return cell;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a row is selected, update the title accordingly
    Person *person = (Person *)[dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    self.title = person.fullname;
}

#pragma mark Searching
#pragma mark Search Bar
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
	aSearchBar.text = @"";
	[dataHelper fetchData];
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText
{
	[dataHelper fetchItemsMatching:aSearchBar.text forAttribute:@"surname" sortingBy:nil];
}

#pragma mark Setup
#define GETINDEX(ATTRIBUTE) [attributes indexOfObject:ATTRIBUTE]
- (void) initializeData
{
    NSArray *attributes = @[@"number", @"gender", @"givenname", @"middleinitial", @"surname", @"streetaddress", @"city", @"state", @"zipcode", @"country", @"emailaddress", @"password", @"telephonenumber", @"mothersmaiden", @"birthday", @"cctype", @"ccnumber", @"cvv2", @"ccexpires", @"nationalid", @"ups", @"occupation", @"domain", @"bloodtype", @"pounds", @"kilograms", @"feetinches", @"centimeters"];
    NSString *dataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakePersons" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lineArray = [dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in lineArray)
    {
        NSArray *items = [line componentsSeparatedByString:@","];
        if (items.count != attributes.count) continue;
        
        Person *person = (Person *)[dataHelper newObject];
        
        person.surname = items[GETINDEX(@"surname")];
        person.section = [[person.surname substringFromIndex:0] substringToIndex:1];
        
        person.emailaddress = items[GETINDEX(@"emailaddress")];
        person.gender = items[GETINDEX(@"gender")];
        person.middleinitial = items[GETINDEX(@"middleinitial")];
        person.occupation = items[GETINDEX(@"occupation")];
        person.givenname = items[GETINDEX(@"givenname")];
    }
    
    if ([dataHelper save])
        NSLog(@"Database created");
}

- (void) loadView
{
    [super loadView];
    
    // Create a search bar
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeAlphabet;
	searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	
	// Create the search display controller
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;

    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"Person";
    dataHelper.defaultSortAttribute = @"surname";
    
    // Check for existing data
    BOOL firstRun = !dataHelper.hasStore;
    
    // Setup core data
    [dataHelper setupCoreData];
    if (firstRun)
        [self initializeData];
    
    [dataHelper fetchData];
    [self.tableView reloadData];
}

// Hide the search bar
- (void) viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic) UIWindow *window;
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
	[_window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}