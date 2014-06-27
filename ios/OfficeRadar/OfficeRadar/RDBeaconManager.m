
#import "RDBeaconManager.h"
#import "RDConstants.h"

@implementation RDBeaconManager

- (void) observeDatabase {
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kCBLDatabaseChangeNotification
                                                      object: [self database]
                                                       queue: nil
                                                  usingBlock: ^(NSNotification *n) {
                                                      NSArray* changes = n.userInfo[@"changes"];
                                                      for (int i=0; i<changes.count; i++) {
                                                          [self handleDbChange:changes[i]];
                                                      }
                                                  }
     ];
    
}

- (void) handleDbChange:(CBLDatabaseChange *)change {
    NSLog(@"Document '%@' changed.", change.documentID);
    
    // if it's not type=beacon, ignore it
    CBLDocument *changedDoc = [[self database] documentWithID:[change documentID]];
    NSString *docType = (NSString *)[changedDoc propertyForKey:kDocType];
    
    // if it's not a beacon doc (possibly because it has been deleted and lost its type field)
    // then ignore it
    if (![docType isEqualToString:kDocTypeBeacon]) {
        return;
    }
    
    // otherwise if its a beacon doc, register it with core location
    // TODO: research dupe registration of core location and see if it causes issues
    
}

@end
