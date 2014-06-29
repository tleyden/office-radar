
#import "RDAppDelegate.h"
#import "RDBeaconManager.h"
#import "RDConstants.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation RDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    [self initCouchbaseLiteDatabase];
    [self initOfficeRadarBeaconManager];
    [self initCouchbaseLiteReplications];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OfficeRadar"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Needed for facebook login 
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)initCouchbaseLiteDatabase {

    NSError *error;
    self.manager = [CBLManager sharedInstance];

    self.database = [[self manager] databaseNamed:kDatabaseName error:&error];
    if (![self database]) {
        NSLog (@"Cannot create/retrieve database. Error message: %@", error.localizedDescription);
    }
    
}

- (void)initOfficeRadarBeaconManager {
    
    self.beaconManager = [[RDBeaconManager alloc] initWithDatabase:[self database]];
    [[self beaconManager] observeDatabase];
    [[self beaconManager] createDbViews];

}

- (void)initCouchbaseLiteReplications {
    NSURL *syncUrl = [NSURL URLWithString:kSyncURL];
    CBLReplication *pullReplication = [[self database] createPullReplication:syncUrl];
    CBLReplication *pushReplication = [[self database] createPushReplication:syncUrl];
    
    [pullReplication setContinuous:YES];
    [pushReplication setContinuous:YES];
    
    [pullReplication start];
    [pushReplication start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pullReplicationProgress:)
                                                 name:kCBLReplicationChangeNotification
                                               object:pullReplication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushReplicationProgress:)
                                                 name:kCBLReplicationChangeNotification
                                               object:pushReplication];
}




-(void)pullReplicationProgress:(NSNotification *)notification {
    NSLog(@"pullReplicationProgress");
}

-(void)pushReplicationProgress:(NSNotification *)notification {
    NSLog(@"pushReplicationProgress");
}





@end
