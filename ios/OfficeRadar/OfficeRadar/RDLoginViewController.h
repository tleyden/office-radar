

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RDLoginViewController : UIViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@end
