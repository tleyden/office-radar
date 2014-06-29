

#import "RDUserHelper.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "RDConstants.h"

@implementation RDUserHelper

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static RDUserHelper *sharedUserHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserHelper = [[self alloc] init];
    });
    return sharedUserHelper;
}

- (NSString *)loggedInUserId {
    
    NSError *error;
    
    // get database
    CBLDatabase *database = [[CBLManager sharedInstance] databaseNamed:kDatabaseName error:&error];
    [self showAlertIfError:error withMessage:@"Unable to get database"];
    
    // find user id from local doc
    NSDictionary *localDoc = [database existingLocalDocumentWithID:kLocalDocUserId];
    if (localDoc == nil) {
        return nil;
    }
    return (NSString *) [localDoc objectForKey:kLocalDocUserId];
    
}

// TODO: this method is duplicated, refactoring needed
- (void)showAlertIfError:(NSError *)error withMessage:(NSString *)message {
    if (error != nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

@end
