    

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
    
    NSLog(@"facebookUserLoggedIn");
    
    NSError *error;

    // get database
    CBLDatabase *database = [RDDatabaseHelper database];
    
    // save local doc with fb user id
    NSString *userId = [user objectID];
    NSDictionary *localDoc = @{kLocalDocUserId: userId};
    [database putLocalDocument:localDoc withID:kLocalDocUserId error:&error];
    if ([self showAlertIfError:error withMessage:@"Unable to save local doc"]) {
        return;
    }
    
    // save new user profile, or update existing
    CBLDocument *userProfileDoc = [database documentWithID:userId];
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];
    [userProfile setName:[user name]];
    [userProfile setAuthSystem:kAuthSystemFacebook];
    [userProfile setValue: [[RDUserProfile class] docType] ofProperty: @"type"];
    
    // this might be a no-op, if the device token hasn't been saved to local doc yet.
    [userProfile addDeviceToken:[self getDeviceTokenLocalDoc]];
    
    [userProfile save:&error];
    if ([self showAlertIfError:error withMessage:@"Unable to save user profile"]) {
        return;
    }
    
}

- (void)updateProfileWithDeviceToken:(NSString *)deviceToken {
    
    NSError *error;
    
    NSLog(@"updateProfileWithDeviceToken called with %@", deviceToken);
    
    NSString *userId = [self loggedInUserId];
    if (userId == nil) {
        NSLog(@"loggedInUserId is null, abort updateProfileWithDeviceToken");
        return;
    }
    CBLDocument *userProfileDoc = [[RDDatabaseHelper database] documentWithID:userId];
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];

    // this might be a no-op, if the device token hasn't been saved to local doc yet.
    [userProfile addDeviceToken:deviceToken];
    
    [userProfile save:&error];
    if ([self showAlertIfError:error withMessage:@"Unable to update user profile with deviceToken"]) {
        return;
    }
    
    NSLog(@"saved user profile (userid = %@) with device token", userId);


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

- (void)saveDeviceTokenLocalDoc:(NSString *)deviceToken {
    
    NSLog(@"saveDeviceTokenLocalDoc, Device token: %@", deviceToken);

    NSError *error;
    NSDictionary *localDoc = @{kLocalDocDeviceToken: deviceToken};
    [[RDDatabaseHelper database] putLocalDocument:localDoc withID:kLocalDocDeviceToken error:&error];
    if ([self showAlertIfError:error withMessage:@"Unable to save local doc"]) {
        return;
    }
    
}


- (NSString *)getDeviceTokenLocalDoc {
    // find user id from local doc
    NSDictionary *localDoc = [[RDDatabaseHelper database] existingLocalDocumentWithID:kLocalDocDeviceToken];
    if (localDoc == nil) {
        return nil;
    }
    return (NSString *) [localDoc objectForKey:kLocalDocDeviceToken];
    
}

- (RDUserProfile *)loggedInUserProfile {
    NSString *userId = [self loggedInUserId];
    if (userId == nil) {
        return nil;
    }
    CBLDocument *userProfileDoc = [[RDDatabaseHelper database] documentWithID:userId];
    if (userProfileDoc == nil) {
        return nil;
    }
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];
    return userProfile;
}



- (BOOL)isAdminLoggedIn {
    RDUserProfile *userProfile = [self loggedInUserProfile];
    if (userProfile == nil) {
        return NO;
    }
    // TODO: add field to user profile instead of this hack
    NSRange range = [userProfile.name rangeOfString:@"Traun"];
    return range.location != NSNotFound;
    
}

// TODO: this method is duplicated, refactoring needed
- (BOOL)showAlertIfError:(NSError *)error withMessage:(NSString *)message {
    if (error != nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return YES;
    }
    return NO;
}

@end
