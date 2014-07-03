
#import "RDMasterViewController.h"

#import "RDDetailViewController.h"
#import "RDBeacon.h"
#import "RDDatabaseHelper.h"
#import "RDBeaconManager.h"
#import "RDConstants.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "RDGeofenceEvent.h"

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
    [query setDescending:YES];
    return [query asLiveQuery];
}

- (void) createDbViews {
    
    CBLView* view = [[RDDatabaseHelper database] viewNamed: kViewGeofenceEvents];
    [view setMapBlock:^(NSDictionary *doc, CBLMapEmitBlock emit) {
        NSString *docType = (NSString *) doc[kDocType];
        if ([docType isEqualToString:kGeofenceEventDocType]) {
            NSDateFormatter *dateFormatter = getISO8601Formatter();
            NSString *createdAtString = doc[kFieldCreatedAt];
            NSDate *createdAt = [dateFormatter dateFromString:createdAtString];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *key = [dateFormat stringFromDate:createdAt];
            emit(key, doc[@"_id"]);
        }
    } version:@"7"];
    
}

static NSDateFormatter* getISO8601Formatter() {
    static NSDateFormatter* sFormatter;
    if (!sFormatter) {
        // Thanks to DenNukem's answer in http://stackoverflow.com/questions/399527/
        sFormatter = [[NSDateFormatter alloc] init];
        sFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        sFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        sFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        sFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    return sFormatter;
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
    RDGeofenceEvent *geofenceEvent = [RDGeofenceEvent modelForDocument:document];
    
    cell.textLabel.text = [geofenceEvent prettyPrint];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:geofenceEvent.created_at];
    
    cell.detailTextLabel.text = dateString;
    
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
