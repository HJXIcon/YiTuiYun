
#import "ZQ_UIAlertView.h"

@interface ZQ_UIAlertView ()<UIAlertViewDelegate>

@end

@implementation ZQ_UIAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    
    if (self = [super init]) {
        self.delegate = self;
        self.title    = nil;
    } else {
        
    }
    
    return self;
}

+ (ZQ_UIAlertView *)showMessage:(NSString *)message cancelTitle:(NSString *)title
{
    return [ZQ_UIAlertView showMessage:message delegate:nil title:@"提示" cancelTitle:title otherButtonTitle:nil];
}

+ (ZQ_UIAlertView *)showMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelTitle:(NSString *)title
{
    return [ZQ_UIAlertView showMessage:message delegate:delegate title:@"提示" cancelTitle:title otherButtonTitle:nil];
}

+ (ZQ_UIAlertView *)showMessage:(NSString *)message cancelTitle:(NSString *)title otherButtonTitle:(NSString *)otherButtonTitle
{
    return [ZQ_UIAlertView showMessage:message delegate:nil title:@"提示" cancelTitle:title otherButtonTitle:otherButtonTitle];
}

+ (ZQ_UIAlertView *)showMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    return [ZQ_UIAlertView showMessage:message delegate:nil title:title cancelTitle:cancleTitle otherButtonTitle:otherButtonTitle];
}

+ (ZQ_UIAlertView *)showMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title cancelTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    ZQ_UIAlertView *alert = [[ZQ_UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancleTitle otherButtonTitles:otherButtonTitle, nil];
    if (!delegate) {
        alert.delegate = alert;
    }
    
//    [alert setMessage:message];
//    [alert setTitle:title];
//    [alert setDelegate:delegate];
//    [alert addCancleTitle:cancleTitle];
//    [alert addButtonTitle:otherButtonTitle];
    [alert show];
    
    return alert;
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}

- (void)addCancleTitle:(NSString *)title
{
    self.cancelButtonIndex = [self addButtonWithTitle:title];
}

- (void)addButtonTitle:(NSString *)title
{
    [self addButtonWithTitle:title];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
}

- (void)alertView:(ZQ_UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickBlock) {
        _clickBlock(alertView,buttonIndex);
    }
}

@end
