
#import <Foundation/Foundation.h>
#import "RDBeaconManager.h"
#import "RDConstants.h"
#import "RDBeacon.h"
#import "RDGeofenceEvent.h"
#import <CouchbaseLite/CouchbaseLite.h>

@implementation RDBeaconManager

- (RDBeaconManager *)initWithDatabase:(CBLDatabase *)database
{
    if (self = [super init]) {
        self.database = database;
        self.estimoteBeaconManager = [[ESTBeaconManager alloc] init];
        self.estimoteBeaconManager.delegate = self;
    }
    return self;
}

- (void) observeDatabase {
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kCBLDatabaseChangeNotification
                                                      object: [self database]
                                                       queue: nil
                                                  usingBlock: ^(NSNotification *n) {
                                                      NSArray* changes = n.userInfo[@"changes"];
                                                      for (int i=0; i<changes.count; i++) {
                                                          [self handleDbChange:changes[i]];
                                                      }
                                                  }
     ];
    
}

- (void) createDbViews {
    
    CBLView* view = [[self database] viewNamed: @"beacons"];
    [view setMapBlock:^(NSDictionary *doc, CBLMapEmitBlock emit) {
        NSString *docType = (NSString *) doc[kDocType];
        if ([docType isEqualToString:kDocTypeBeacon]) {
            NSString *uuid = (NSString *) doc[kFieldUuid];
            NSNumber *major = (NSNumber *) doc[kFieldMajor];
            NSNumber *minor = (NSNumber *) doc[kFieldMinor];
            NSArray *key = [NSArray arrayWithObjects:uuid, major, minor, nil];
            emit(key, doc[@"_id"]);
        }
        
    } version:@"1"];

    
}

- (void) handleDbChange:(CBLDatabaseChange *)change {
    
    NSLog(@"Document '%@' changed.", change.documentID);
    
    // if it's not type=beacon, ignore it
    CBLDocument *changedDoc = [[self database] documentWithID:[change documentID]];
    NSString *docType = (NSString *)[changedDoc propertyForKey:kDocType];
    
    // if it's not a beacon doc (possibly because it has been deleted and lost its type field)
    // then ignore it
    if (![docType isEqualToString:kDocTypeBeacon]) {
        return;
    }
    
    NSString *uuidStr = (NSString *) [changedDoc propertyForKey:kFieldUuid];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
    NSNumber *major = (NSNumber *) [changedDoc propertyForKey:kFieldMajor];
    NSNumber *minor = (NSNumber *) [changedDoc propertyForKey:kFieldMinor];
    
    // otherwise if its a beacon doc, register it with core location
    // TODO: research dupe registration of core location and see if it causes issues
    ESTBeaconRegion *beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 major:[major intValue]
                                                                 minor:[minor intValue]
                                                            identifier:@"RegionIdentifier"];
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    [self.estimoteBeaconManager startMonitoringForRegion:beaconRegion];
    
    RDBeacon *beacon = [RDBeacon beaconForRegion:beaconRegion inDatabase:[self database]];
    NSLog(@"beacon: %@", beacon);
    
    [self saveGeofenceForRegion:beaconRegion action:kActionEntry];

    
    
}

- (void)saveGeofenceForRegion:(ESTBeaconRegion *)region action:(NSString *)action {
    
    RDBeacon *beacon = [RDBeacon beaconForRegion:region inDatabase:[self database]];
    
    RDGeofenceEvent *geofenceEvent = [[RDGeofenceEvent alloc] initInDatabase:[self database]
                                                                  withBeacon:beacon
                                                                      userID:@"unknown@couchbase.com"
                                                                      action:action];

    
    NSError *error;
    BOOL saved = [geofenceEvent save:&error];
    
    CBLDocument *document = [geofenceEvent document];
    NSLog(@"document properties: %@", [document properties]);
    
    if (!saved) {
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = @"OfficeRadar: failed to save geofence event";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"OfficeRadar: enter";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self saveGeofenceForRegion:region action:kActionEntry];
    
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"OfficeRadar: exit";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self saveGeofenceForRegion:region action:kActionExit];

    
}




@end
