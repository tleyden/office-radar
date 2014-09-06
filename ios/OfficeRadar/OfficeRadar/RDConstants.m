

#import "RDConstants.h"

@implementation RDConstants

NSString *const kSyncURL = @"http://demo.mobile.couchbase.com/officeradar";
//NSString *const kSyncURL = @"http://localhost:4984/officeradar";

NSString *const kDocType = @"type";
NSString *const kDocTypeBeacon = @"beacon";
NSString *const kFieldUuid = @"uuid";
NSString *const kFieldMajor = @"major";
NSString *const kFieldMinor = @"minor";
NSString *const kActionEntry = @"entry";
NSString *const kActionExit = @"exit";
NSString *const kGeofenceEventDocType = @"geofence_event";
NSString *const kBeaconDocType = @"beacon";
NSString *const kFieldId = @"_id";
NSString *const kViewBeacons = @"beacons";
NSString *const kDatabaseName = @"office_radar";
NSString *const kLocalDocUserId = @"user_id";
NSString *const kLocalDocDeviceToken = @"device_token";
NSString *const kUserProfileDocType = @"profile";
NSString *const kAuthSystemFacebook = @"facebook";
NSString *const kViewGeofenceEvents = @"geofence_events";
NSString *const kFieldCreatedAt = @"created_at";



@end
