
#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface RDBeaconManager : NSObject

@property (strong, nonatomic) CBLDatabase *database;

- (void) observeDatabase;

@end
