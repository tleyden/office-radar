
#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>


/** All interaction with the replications should happen through this helper */

@interface RDSyncHelper : NSObject

/* Singleton */
+ (id)sharedInstance;

@property (readwrite) CBLReplication* pullReplication;

@property (readwrite) CBLReplication* pushReplication;

- (void)startSyncWithExistingFacebookSession;

@end
