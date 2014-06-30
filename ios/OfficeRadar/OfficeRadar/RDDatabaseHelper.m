
#import "RDDatabaseHelper.h"
#import "RDConstants.h"

@implementation RDDatabaseHelper

+ (CBLDatabase *)database {
    
    NSError *error;
    CBLDatabase *database = [[CBLManager sharedInstance] databaseNamed:kDatabaseName error:&error];
    if (!database) {
        NSLog (@"Cannot create/retrieve database. Error message: %@", error.localizedDescription);
        NSException *exception = [NSException exceptionWithName:@"Cannot retreive database"
                                                         reason:error.localizedDescription
                                                       userInfo:nil];
        @throw exception;
    }
    
    return database;

}

@end
