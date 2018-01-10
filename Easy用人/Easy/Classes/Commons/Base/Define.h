//
//  Define.h
//  JXProjectFramework
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef Define_h
#define Define_h

/**! DocumentDirectory路径*/
#define E_DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/**! App信息 */
#define E_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define E_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define E_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

/**! 屏幕适配*/
#define kScreenW ([UIScreen mainScreen].bounds.size.width)
#define kScreenH ([UIScreen mainScreen].bounds.size.height)


/**! Dubug相关*/
#ifdef DEBUG
#define JXLog(format,...)  NSLog((@"[函数名:%s]\n" "[行号:%d]\n" format),__FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define JXLog(...)
#endif

/// 微信
#if DEBUG
#define WechatAppID            @"wx40fc8b8a0744c4fe"
#else
#define WechatAppID           @"wxef0a28a49b3615af"
#endif


// 弱引用
#define JXWeak(type) __weak typeof(type) weak##type = type
// 强引用
#define JXStrong(type) __strong typeof(type) strong##type = type



// 比例
#define E_RealWidth(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)
#define E_RealHeight(I)  I*[UIScreen mainScreen].bounds.size.height/667.0f

// 箭头图片
#define E_ArrowImage [UIImage imageNamed:@"common_icon_arrow"]
// 美工标出的字体大小 28px = 28 / 2 * 96 / 72 = 18.666
#define E_PSFont(I) I * 0.5 * 96 / 72
#define E_FontRadio(I)  I*[UIScreen mainScreen].bounds.size.width/375.0f
#define E_PSFontRadio(I) E_FontRadio(E_PSFont(I))



// >>>>>> 适配iOS 11、iPhone X
#pragma mark -  *** 适配iOS 11、iPhone X

#define isIOS11 [[UIDevice currentDevice].systemVersion floatValue] >= 11

/// 底部宏，吃一见长一智吧，别写数字了
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhone5s ([UIScreen mainScreen].bounds.size.width>=320.0f && [UIScreen mainScreen].bounds.size.height>=568.0f && IS_IPHONE)
#define iPhoneX ([UIScreen mainScreen].bounds.size.width>=375.0f && [UIScreen mainScreen].bounds.size.height>=812.0f && IS_IPHONE)

// 状态栏高度
#define E_StatusBarHeight (iPhoneX ? 44.f : 20.f)
// 导航条高度
#define E_NavigationBarHeight  44.f


// tabbar 高度
#define E_TabbarHeight (iPhoneX ? (49.f+34.f) : 49.f)
// tabbarSafe
#define E_TabbarSafeBottomMargin (iPhoneX ? 34.f : 0.f)


// 导航栏默认高度
#define  E_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
#define  E_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


/**!
 iOS11设备上运行出现最多问题应该就是tableview莫名奇妙的偏移20pt或者64pt了。
 原因是iOS11弃用了automaticallyAdjustsScrollViewInsets属性，取而代之的
 是UIScrollView新增了contentInsetAdjustmentBehavior属性，这一切的罪魁
 祸首都是新引入的safeArea;
 */
// 适配TableView、ScrollView、CollectionView
#define  adjustsScrollViewInsets(scrollView)\
do {\
    _Pragma("clang diagnostic push")\
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
    if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
        NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
        NSInteger argument = 2;\
        invocation.target = scrollView;\
        invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
        [invocation setArgument:&argument atIndex:2];\
        [invocation retainArguments];\
        [invocation invoke];\
        }\
    _Pragma("clang diagnostic pop")\
    } while (0)

// 适配iOS11 scrollView不偏移64p
// self.automaticallyAdjustsScrollViewInsets = NO;
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)



// 颜色
#define EThemeColor [UIColor colorWithHexString:@"#ffbf00"]
#define EBackgroundColor [UIColor colorWithHexString:@"#f2eee4"]
#define EHighlightedColor [UIColor colorWithHexString:@"#f0e9d8"]

/// 占位图片
#define E_PlaceholderImage [UIImage imageNamed:@"touxiang"]
#define E_FullImagePath(string) [NSString stringWithFormat:@"%@/global/file/%@",kApiPrefix,string]

// 友盟appleKey
#define UMAppleKey @"5a0ab768f29d987154000012"



// ----- !***  判断  *** ----- ///
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]])

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/// 存手机号码
#define E_MobileKey @"E_MobileKey"


#endif /* Define_h */
