

#import <Foundation/Foundation.h>
#import "RDBeacon.h"
#import "RDConstants.h"
#import <CouchbaseLite/CouchbaseLite.h>

@implementation RDBeacon

@dynamic uuid, major, minor;

+ (NSString*) docType {
    return kBeaconDocType;
}

+ (RDBeacon*) beaconForRegion:(ESTBeaconRegion*)region inDatabase:(CBLDatabase *)database {
    
    // create key to query on
    NSUUID *uuid = [region proximityUUID];
    NSString *uuidStr = [uuid UUIDString];
    NSNumber *major = [region major];
    NSNumber *minor = [region minor];
    
    NSArray *queryKey = @[uuidStr, major, minor];
    
    // create query
    CBLQuery* query = [[database viewNamed:kViewBeacons] createQuery];
    query.limit = 1;
    query.startKey = queryKey;
    query.endKey = queryKey;
    
    // run query to find document
    CBLDocument *beaconDocument;
    NSError *error;
    CBLQueryEnumerator* result = [query run: &error];
    
    for (CBLQueryRow* row in result) {
        NSLog(@"Found beacon for key: %@ beacon id: %@", row.key, row.value);
        beaconDocument = [database documentWithID:row.value];
        break;
    }
    
    // get a model for the document
    RDBeacon *beacon = [RDBeacon modelForDocument:beaconDocument];
    
    return beacon;
    
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                       withUuid: (NSString*)uuid
                          major: (NSNumber*)major
                          minor: (NSNumber*)minor {
    
    self = [super initWithNewDocumentInDatabase: database];
    if (self) {
        // The "type" property identifies what type of document this is.
        // It's used in map functions and by the CBLModelFactory.
        [self setValue: [[self class] docType] ofProperty: @"type"];
        self.uuid = uuid;
        self.major = major;
        self.minor = minor;
    }
    return self;

}

@end
