
#import <CouchbaseLite/CouchbaseLite.h>

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

@end
