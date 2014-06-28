

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ESTBeaconManager.h"
#import "RDBeacon.h"

/** Whenever the user enters or exits a beacon geofence, record a raw event. */

@interface RDGeofenceEvent : CBLModel

/** The "type" property value for documents that belong to this class. */
+ (NSString*) docType;

/** The user_id is usually an email address. */
@property (readwrite) NSString* user_id;

/** The beacon. */
@property (readwrite) RDBeacon* beacon;

/** The "action" of the event, either ENTRY or EXIT */
@property (readwrite) NSString* action;

/** When this event occurred */
@property (readwrite) NSDate* created_at;

/** initializer */
- (instancetype) initInDatabase: (CBLDatabase*)database
                     withBeacon: (RDBeacon*)beacon
                         userID: (NSString*)userId
                         action: (NSString*)action;


@end
