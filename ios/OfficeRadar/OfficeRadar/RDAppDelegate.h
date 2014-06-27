
#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "RDBeaconManager.h"


@interface RDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBLManager *manager;
@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) RDBeaconManager *beaconManager;


@end
