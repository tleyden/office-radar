

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ESTBeaconManager.h"
#import "RDBeacon.h"
#import "RDUserProfile.h"

/** Whenever the user enters or exits a beacon geofence, record a raw event. */

@interface RDGeofenceEvent : CBLModel

/** The "type" property value for documents that belong to this class. */
+ (NSString*) docType;

/** The user_id. In facebook case, it's a big number. */
@property (readwrite) RDUserProfile* profile;

/** The beacon. */
@property (readwrite) RDBeacon* beacon;

/** The "action" of the event, either ENTRY or EXIT */
@property (readwrite) NSString* action;

/** When this event occurred */
@property (readwrite) NSDate* created_at;

/** initializer */
- (instancetype) initInDatabase: (CBLDatabase*)database
                     withBeacon: (RDBeacon*)beacon
                        profile: (RDUserProfile*)profile
                         action: (NSString*)action;

/** Get a friendly description of this suitable for showing in UI */
- (NSString *) prettyPrint;



@end
