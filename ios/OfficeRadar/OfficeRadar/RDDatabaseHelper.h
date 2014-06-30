

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface RDDatabaseHelper : NSObject

/** get the couchbase lite database */
+ (CBLDatabase *)database;

@end
