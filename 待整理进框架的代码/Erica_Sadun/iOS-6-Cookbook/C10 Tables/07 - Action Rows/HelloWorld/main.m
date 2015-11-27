/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

/*
 
 Many thanks to Bilal S. Sayed Ahmad for suggesting this recipe and providing coding inspiration.
 
 */

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "NSIndexPathUtilities.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UITableViewController
{
    NSArray *items;
}
@property (nonatomic) NSIndexPath *actionRowPath;
@end

@implementation TestBedViewController

#pragma mark Data Source

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return items.count + (self.actionRowPath != nil);
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.actionRowPath isEqual:indexPath])
    {
        // Action Row
        CustomCell *cell = (CustomCell *)[self.tableView dequeueReusableCellWithIdentifier:@"action" forIndexPath:indexPath];
        [cell setActionTarget:self];
        return cell;
    }
    else
    {
        // Normal Cell
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        // Adjust item row around action row if needed
        NSInteger adjustedRow = indexPath.row;
        if (_actionRowPath && (_actionRowPath.row < indexPath.row)) adjustedRow--;        
        cell.textLabel.text = [items objectAtIndex:adjustedRow];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
}

#pragma mark Delegate

// Deselect any current selection
- (void) deselect
{
    NSArray *paths = [self.tableView indexPathsForSelectedRows];
    if (!paths.count) return;
    
    NSIndexPath *path = paths[0];
    [self.tableView deselectRowAtIndexPath:path animated:YES];
}

// On selection, update the title and enable find/deselect
- (void)tableView: (UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pathsToAdd;
    NSArray *pathsToDelete;
    
    if ([self.actionRowPath.previous isEqual:indexPath])
    {
        // Hide Action Cell
        pathsToDelete = @[self.actionRowPath];
        self.actionRowPath = nil;
        [self deselect];
    }
    else if (self.actionRowPath)
    {
        // Move Action Cell
        pathsToDelete = @[self.actionRowPath];
        BOOL before = [indexPath before:self.actionRowPath];
        NSIndexPath *newPath = before ? indexPath.next : indexPath;
        pathsToAdd = @[newPath];
        self.actionRowPath = newPath;
    }
    else
    {
        // New Action Cell
        pathsToAdd = @[indexPath.next];
        self.actionRowPath = indexPath.next;
    }
    
    // Perform the deletions and insertions
    [self.tableView beginUpdates];
    if (pathsToDelete.count)
        [self.tableView deleteRowsAtIndexPaths:pathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    if (pathsToAdd.count)
        [self.tableView insertRowsAtIndexPaths:pathsToAdd withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Only select normal cells
    if([indexPath isEqual:self.actionRowPath]) return nil;
    return indexPath;
}

#pragma mark Button target methods

- (void) clearTitle
{
    self.title = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) buttonPushed: (UIButton *) sender
{
    NSArray *paths = [self.tableView indexPathsForSelectedRows];
    if (!paths.count) return;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:paths[0]];
    NSString *cellTitle = cell.textLabel.text;
    
    switch (sender.tag)
    {
        case CustomCellActionAlert:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cellTitle message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
        case CustomCellActionTitle:
        {
            self.title = cellTitle;
            self.navigationItem.rightBarButtonItem = BARBUTTON(@"X", @selector(clearTitle));
            break;
        }
        default:
            break;
    }
}

#pragma mark Table setup

// Set up table
- (void) loadView
{
    [super loadView];
    self.tableView.rowHeight = 60.0f;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"action"];
    
    items = [@"Alpha Bravo Charlie Delta Echo Foxtrot Golf Hotel India Juliet Kilo Lima Mike November Oscar Papa Romeo Quebec Sierra Tango Uniform Victor Whiskey Xray Yankee Zulu" componentsSeparatedByString:@" "];
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}