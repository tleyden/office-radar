

#import "RDUserProfile.h"
#import "RDConstants.h"
#import "RDDatabaseHelper.h"

@implementation RDUserProfile

@dynamic authSystem, name, photoUrl, email;

+ (NSString*) docType {
    return kUserProfileDocType;
}

+ (instancetype) profileWithUserId:(NSString *)userId {
    
    CBLDocument *userProfileDoc = [[RDDatabaseHelper database] existingDocumentWithID:userId];
    RDUserProfile *userProfile = [RDUserProfile modelForDocument:userProfileDoc];
    return userProfile;

}

@end
