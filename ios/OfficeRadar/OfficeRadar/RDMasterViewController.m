
#import "RDMasterViewController.h"

#import "RDDetailViewController.h"
#import "RDBeacon.h"
#import "RDDatabaseHelper.h"
#import "RDBeaconManager.h"
#import "RDConstants.h"
#import <CouchbaseLite/CouchbaseLite.h>

@interface RDMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation RDMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (RDDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self createDbViews];
    
    self.tableSource = [[CBLUITableSource alloc] init];
    self.tableSource.query = [self createLiveQuery];
    self.tableSource.tableView = self.tableView;
    
    [[self tableView] setDataSource:self.tableSource];
    
    
}

- (CBLLiveQuery *) createLiveQuery {
    CBLQuery* query = [[[RDDatabaseHelper database] viewNamed:kViewGeofenceEvents] createQuery];
    return [query asLiveQuery];
}

- (void) createDbViews {
    
    CBLView* view = [[RDDatabaseHelper database] viewNamed: kViewGeofenceEvents];
    [view setMapBlock:^(NSDictionary *doc, CBLMapEmitBlock emit) {
        NSString *docType = (NSString *) doc[kDocType];
        if ([docType isEqualToString:kGeofenceEventDocType]) {
            NSDate *createdAt = (NSDate *) doc[kFieldCreatedAt];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateStyle:NSDateFormatterShortStyle];
            NSString *dateString = [dateFormat stringFromDate:createdAt];
            emit(dateString, doc[@"_id"]);
        }
        
    } version:@"1"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    
    RDBeacon *beacon = [RDBeacon firstBeaconInDatabase:[RDDatabaseHelper database]];
    RDBeaconManager *beaconManager = [[RDBeaconManager alloc] initWithDatabase:[RDDatabaseHelper database]];
    [beaconManager saveGeofenceForBeacon:beacon action:kActionEntry];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
