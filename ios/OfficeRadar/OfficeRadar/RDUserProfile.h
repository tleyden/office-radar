
#import <CouchbaseLite/CouchbaseLite.h>

@class RDGeofenceEvent;

/* Additional information of an OfficeRadar user */
@interface RDUserProfile : CBLModel

/** The "type" property value for documents that belong to this class. */
+ (NSString*) docType;

/** Get the userprofile associated with giver userId */
+ (instancetype) profileWithUserId:(NSString *)userId;

/** The system under which they were authenticated, eg, Facebook */
@property (readwrite) NSString* authSystem;

/** The user's name. */
@property (readwrite) NSString* name;

/** The user's photo url. */
@property (readwrite) NSString* photoUrl;

/** The user's email. */
@property (readwrite) NSString* email;

/** The user's device tokens. */
@property (readwrite) NSArray* deviceTokens;

/** The latest geofence event recorded by the user. */
@property (readwrite) RDGeofenceEvent* latestEvent;

/** 
 When the latest geofence event for this user happened 
 NOTE: see http://bit.ly/1D8Ug7T for discussion
 */
@property (readwrite) NSDate* latestEventCreatedAt;

/** Add a new device token */
- (void)addDeviceToken:(NSString *)deviceToken;

@end
