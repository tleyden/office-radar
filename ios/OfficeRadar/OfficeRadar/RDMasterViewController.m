
#import "RDMasterViewController.h"

#import "RDDetailViewController.h"
#import "RDBeacon.h"
#import "RDDatabaseHelper.h"
#import "RDBeaconManager.h"
#import "RDConstants.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "RDGeofenceEvent.h"
#import "RDUserHelper.h"

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

    
    self.tableSource = [[CBLUITableSource alloc] init];
    self.tableSource.query = [self createLiveQuery];
    self.tableSource.tableView = self.tableView;
    
    [[self tableView] setDataSource:self.tableSource];
    

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
          target:self
          action:@selector(insertNewObject:)];
    
    
}

- (CBLLiveQuery *) createLiveQuery {
    CBLQuery* query = [[[RDDatabaseHelper database] viewNamed:kLastSeenUsers] createQuery];
    [query setDescending:YES];
    return [query asLiveQuery];
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

#pragma mark - CBLUITableSource

- (UITableViewCell *)couchTableSource:(CBLUITableSource*)source
                cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    CBLDocument *document = [source documentAtIndexPath:indexPath];

    
    cell.textLabel.text = [[document properties] valueForKey:@"name"];

    /*
    RDGeofenceEvent *geofenceEvent = [RDGeofenceEvent modelForDocument:document];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:geofenceEvent.created_at];
    
    cell.detailTextLabel.text = dateString;
*/
    
    return cell;

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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}
*/

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
