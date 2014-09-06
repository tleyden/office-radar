
#import "RDSyncHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RDDatabaseHelper.h"
#import "RDConstants.h"

@implementation RDSyncHelper

@synthesize pullReplication;
@synthesize pushReplication;

+ (id)sharedInstance {
    
    static RDSyncHelper *sharedSyncHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSyncHelper = [[self alloc] init];
    });
    return sharedSyncHelper;
}

- (void)startSyncWithExistingFacebookSession {
    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    id<CBLAuthenticator> fbAuthenticator = [CBLAuthenticator facebookAuthenticatorWithToken:accessToken];
    [self startSyncWithAuthenticator:fbAuthenticator];
}

- (void)startSyncWithAuthenticator:(id<CBLAuthenticator>)authenticator {
    
    NSURL *syncUrl = [NSURL URLWithString:kSyncURL];
    
    // workaround for issue where 
    if (self.pullReplication != nil) {
        NSLog(@"Replications are already running, ignoring call to startSyncWithAuthenticator");
        return;
    }
    
    self.pullReplication = [[RDDatabaseHelper database] createPullReplication:syncUrl];
    self.pushReplication = [[RDDatabaseHelper database] createPushReplication:syncUrl];
    
    [self.pullReplication setAuthenticator:authenticator];
    [self.pushReplication setAuthenticator:authenticator];
    
    [self.pullReplication setContinuous:YES];
    [self.pushReplication setContinuous:YES];
    
    [self.pullReplication start];
    [self.pushReplication start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replicationProgress:)
                                                 name:kCBLReplicationChangeNotification
                                               object:pullReplication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replicationProgress:)
                                                 name:kCBLReplicationChangeNotification
                                               object:pushReplication];
    

}


-(void)replicationProgress:(NSNotification *)notification {
    
    CBLReplication *repl = [notification object];
    [self replicationProgress:repl notification:notification];
    
}

-(void)replicationProgress:(CBLReplication *)repl notification:(NSNotification *)notification {
    bool active = false;
    unsigned completed = 0, total = 0;
    CBLReplicationStatus status = kCBLReplicationStopped;
    NSError *error = nil;
    status = MAX(status, repl.status);
    if (!error)
        error = repl.lastError;
    if (repl.status == kCBLReplicationActive) {
        active = true;
        completed += repl.completedChangesCount;
        total += repl.changesCount;
    }
    
    if (error.code == 401) {
        NSLog(@"401 auth error");
    }
    
    if (repl.pull) {
        NSLog(@"Pull: active=%d; status=%d; %u/%u; %@",
              active, status, completed, total, error.localizedDescription);
    } else {
        NSLog(@"Push: active=%d; status=%d; %u/%u; %@",
              active, status, completed, total, error.localizedDescription);
    }
    
}



@end
