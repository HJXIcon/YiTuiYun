
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface MainViewController : UITabBarController
- (void)setupSubviews;//重新加载视图
- (void)againLogin;
- (void)refreshInterface;
- (void)jumpAPP:(NSDictionary *)dic;
- (void)jumpH5:(NSDictionary *)dic;
- (void)customMessage:(NSDictionary *)dic;
- (void)setupUnreadMessageCount;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;
@end

