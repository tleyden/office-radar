    

#import "RDUserHelper.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "RDConstants.h"
#import "RDDatabaseHelper.h"
#import "RDUserProfile.h"

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

- (void)facebookUserLoggedIn:(id<FBGraphUser>)user {
    
    NSError *error;

    // get database
    CBLDatabase *database = [RDDatabaseHelper database];
    
    // save local doc with fb user id
    NSString *userId = [user objectID];
    NSDictionary *localDoc = @{kLocalDocUserId: userId};
    [database putLocalDocument:localDoc withID:kLocalDocUserId error:&error];
    [self showAlertIfError:error withMessage:@"Unable to save local doc"];
    
    // save new user profile, or update existing
    CBLDocument *userProfileDoc = [database documentWithID:userId];
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];
    [userProfile setName:[user name]];
    [userProfile setAuthSystem:kAuthSystemFacebook];
    [userProfile save:&error];
    [self showAlertIfError:error withMessage:@"Unable to save user profile"];
    
    
}

- (void)facebookUserLoggedOut {
    
    NSError *error;
    
    // get database
    CBLDatabase *database = [RDDatabaseHelper database];
    
    // delete local doc with fb user id
    [database deleteLocalDocumentWithID:kLocalDocUserId error:&error];
    
    // TODO: shouldn't ignore error here.  fix by first checking
    // for record, and then only deleting if exists.  (and then check for error
    // and show alert if delete failed)
    
}

- (NSString *)loggedInUserId {
    
    // get database
    CBLDatabase *database = [RDDatabaseHelper database];
    
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
