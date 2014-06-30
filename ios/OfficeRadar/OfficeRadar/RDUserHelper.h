

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RDUserHelper : NSObject

/* Singleton */
+ (id)sharedInstance;

/* Get the user id of the logged in user, if any.  Otherwise return nil. */
- (NSString *)loggedInUserId;

/* Record the fact that a user logged into app w/ facebook */
- (void)facebookUserLoggedIn:(id<FBGraphUser>)user;

/* Record the fact that facebook user logged out*/
- (void)facebookUserLoggedOut;


@end
