

#import <Foundation/Foundation.h>

@interface RDUiHelper : NSObject

+ (void)showLocalNotificationError:(NSString *)message error:(NSError *)error;

+ (void)showLocalNotification:(NSString *)message;

    
@end
