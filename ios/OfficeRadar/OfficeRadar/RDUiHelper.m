

#import "RDUiHelper.h"

@implementation RDUiHelper

+ (void)showLocalNotificationError:(NSString *)message error:(NSError *)error {
    NSString *fullError = [NSString stringWithFormat:@"%@ - %@", message, error];
    NSLog(@"%@", fullError);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

+ (void)showLocalNotification:(NSString *)message {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


@end
