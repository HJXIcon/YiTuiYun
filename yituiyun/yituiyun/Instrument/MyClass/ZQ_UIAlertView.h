

#import <UIKit/UIKit.h>

@class ZQ_UIAlertView;

typedef void (^ZQAlertViewButtonClickBlock)(ZQ_UIAlertView *alertView, NSInteger clickIndex);

@interface ZQ_UIAlertView : UIAlertView

@property (nonatomic, strong) NSObject *userData;
@property (nonatomic, copy)   ZQAlertViewButtonClickBlock clickBlock;

+ (ZQ_UIAlertView *)showMessage:(NSString *)message cancelTitle:(NSString *)title;
+ (ZQ_UIAlertView *)showMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelTitle:(NSString *)title;
+ (ZQ_UIAlertView *)showMessage:(NSString *)message cancelTitle:(NSString *)title otherButtonTitle:(NSString *)otherButtonTitle;
+ (ZQ_UIAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherButtonTitle;
+ (ZQ_UIAlertView *)showMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title cancelTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherButtonTitle;


- (void)dismissAnimated:(BOOL)animated;

- (void)addCancleTitle:(NSString *)title;
- (void)addButtonTitle:(NSString *)title;

@end
