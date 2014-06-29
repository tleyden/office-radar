

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RDLoginViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
