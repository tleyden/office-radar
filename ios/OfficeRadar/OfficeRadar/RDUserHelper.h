

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@class RDUserProfile;

@interface RDUserHelper : NSObject

/* Singleton */
+ (id)sharedInstance;

/* Get the user id of the logged in user, if any.  Otherwise return nil. */
- (NSString *)loggedInUserId;

/* Get the user profile of the logged in user, if any.  Otherwise return nil */
- (RDUserProfile *)loggedInUserProfile;

/* Record the fact that a user logged into app w/ facebook */
- (void)facebookUserLoggedIn:(id<FBGraphUser>)user;

/* Record the fact that facebook user logged out*/
- (void)facebookUserLoggedOut;

/* Is the logged in user an admin? */
- (BOOL)isAdminLoggedIn;

/* Save the device token in a local doc */
- (void)saveDeviceTokenLocalDoc:(NSString *)deviceToken;

/* Update user profile to add device token */
- (void)updateProfileWithDeviceToken:(NSString *)deviceToken;


@end
