
#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ESTBeaconManager.h"


/** A beacon represents a physical real world iBeacon. */

@interface RDBeacon : CBLModel


/** The "type" property value for documents that belong to this class. */
+ (NSString*) docType;

/** Find the RDBeacon model instance corresponding to given ESTBeaconRegion */
+ (RDBeacon*) beaconForRegion:(ESTBeaconRegion*)region inDatabase:(CBLDatabase *)database;

/** Find the first beacon in the db (useful for testing/experimenting) */
+ (RDBeacon*) firstBeaconInDatabase:(CBLDatabase *)database;

/** The uuid of the beacon.  Together with major and minor, these uniquely identify beacon */
@property (readwrite) NSString* uuid;

/** The major number of beacon.  See estimote docs for an explanation */
@property (readwrite) NSNumber* major;

/** The minor number of beacon.  See estimote docs for an explanation */
@property (readwrite) NSNumber* minor;

/** initializer */
- (instancetype) initInDatabase: (CBLDatabase*)database
                       withUuid: (NSString*)uuid
                          major: (NSNumber*)major
                          minor: (NSNumber*)minor;


@end
