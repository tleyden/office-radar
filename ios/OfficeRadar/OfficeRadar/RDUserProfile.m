

#import "RDUserProfile.h"
#import "RDConstants.h"
#import "RDDatabaseHelper.h"

@implementation RDUserProfile

@dynamic authSystem, name, photoUrl, email, deviceTokens;

+ (NSString*) docType {
    return kUserProfileDocType;
}

+ (instancetype) profileWithUserId:(NSString *)userId {
    
    CBLDocument *userProfileDoc = [[RDDatabaseHelper database] existingDocumentWithID:userId];
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];
    return userProfile;

}

- (void)addDeviceToken:(NSString *)deviceToken {
    
    NSLog(@"addDeviceToken called with: %@", deviceToken);

    if (deviceToken == nil) {
        return;
    }
    
    if (self.deviceTokens == nil || [self.deviceTokens count] == 0) {
        self.deviceTokens = [[NSArray alloc] initWithObjects:deviceToken, nil];
    } else {
        if (![self.deviceTokens containsObject:deviceToken]) {
            NSMutableArray *newDeviceTokens = [[NSMutableArray alloc] initWithArray:self.deviceTokens];
            [newDeviceTokens addObject:deviceToken];
            self.deviceTokens = [[NSArray alloc] initWithArray:newDeviceTokens];
        }
    }
    
    
}

@end
