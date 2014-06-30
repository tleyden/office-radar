

#import "RDGeofenceEvent.h"
#import "RDConstants.h"

@implementation RDGeofenceEvent

@dynamic beacon, created_at, userProfile, action;

+ (NSString*) docType {
    return kGeofenceEventDocType;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                     withBeacon: (RDBeacon*)beacon
                    userProfile: (RDUserProfile*)userProfile
                         action: (NSString*)action {
    
    self = [super initWithNewDocumentInDatabase: database];
    if (self) {
        // The "type" property identifies what type of document this is.
        // It's used in map functions and by the CBLModelFactory.
        [self setValue: [[self class] docType] ofProperty: @"type"];
        self.beacon = beacon;
        self.userProfile = userProfile;
        self.action = action;
        self.created_at = [NSDate date];
    }
    return self;


}

@end
