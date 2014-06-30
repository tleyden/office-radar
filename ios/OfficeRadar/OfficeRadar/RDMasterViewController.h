
#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>

@class RDDetailViewController;

@interface RDMasterViewController : UITableViewController <CBLUITableDelegate>

@property (strong, nonatomic) RDDetailViewController *detailViewController;
@property (strong, nonatomic) CBLUITableSource *tableSource;

@end
