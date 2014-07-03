
#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ESTBeaconManager.h"
#import "RDBeacon.h"

@interface RDBeaconManager : NSObject <ESTBeaconManagerDelegate>

@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) ESTBeaconManager *estimoteBeaconManager;

- (RDBeaconManager *)initWithDatabase:(CBLDatabase *)database;
- (void)observeDatabase;
- (void)createDbViews;
- (void)saveGeofenceForBeacon:(RDBeacon *)beacon action:(NSString *)action;
- (void)monitorAllBeacons;

@end
