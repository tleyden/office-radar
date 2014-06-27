
#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ESTBeaconManager.h"

@interface RDBeaconManager : NSObject <ESTBeaconManagerDelegate>

@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) ESTBeaconManager *estimoteBeaconManager;

- (RDBeaconManager *)initWithDatabase:(CBLDatabase *)database;
- (void) observeDatabase;

@end
