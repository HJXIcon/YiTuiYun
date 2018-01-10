//
//  HFTextView.m
//  EasyRepair
//
//  Created by joyman04 on 16/3/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "HFTextView.h"
#import <CoreText/CoreText.h>
#import "ILRegularExpressionManager.h"
#import "NSArray+NSArray_ILExtension.h"
#import "NSString+NSString_ILExtension.h"
#import "UIColor+HFExtension.h"

typedef NS_ENUM(NSInteger, GestureType) {
    
    TapGesType = 1,
    LongGesType,
    
};

@implementation HFTextView{
    
    NSString *_oldString;//未替换含有如[em:02:]的字符串
    NSString *_newString;//替换过含有如[em:02:]的字符串
    
    NSMutableArray *_selectionsViews;
    
    CTTypesetterRef typesetter;
    CTFontRef helvetica;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectionsViews = [NSMutableArray arrayWithCapacity:0];
        _isFold = YES;
        _canClickAll = YES;//默认可点击全部
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself:)];
        [self addGestureRecognizer:tapGes];
        
//        _replyIndex = -1;//默认为-1 代表点击的是说说的整块区域
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMyself:)];
        [self addGestureRecognizer:longGes];
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectionsViews = [NSMutableArray arrayWithCapacity:0];
        _isFold = YES;
        _canClickAll = YES;//默认可点击全部
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself:)];
        [self addGestureRecognizer:tapGes];
        
//        _replyIndex = -1;//默认为-1 代表点击的是说说的整块区域
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMyself:)];
        [self addGestureRecognizer:longGes];
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString{
    
    _oldString = oldString;
    _newString = newString;
    [self cookEmotionString];
}


#pragma mark -
- (void)cookEmotionString{
    
    // 使用正则表达式查找特殊字符的位置
    NSArray *itemIndexes = [ILRegularExpressionManager itemIndexesWithPattern:
                            EmotionItemPattern inString:_oldString];
    
    NSArray *names = nil;
    
    NSArray *newRanges = nil;
    
    names = [_oldString itemsForPattern:EmotionItemPattern captureGroupIndex:1];
    
    newRanges = [itemIndexes offsetRangesInArrayBy:[PlaceHolder length]];
    _emotionNames = names;
    _attrEmotionString = [self createAttributedEmotionStringWithRanges:newRanges
                                                             forString:_newString];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                        (_attrEmotionString));
    
    if (_isDraw == NO) {
        // CFRelease(typesetter);
        return;
    }
    [self setNeedsDisplay];
}

/**
 *  根据调整后的字符串，生成绘图时使用的 attribute string
 *
 *  @param ranges  占位符的位置数组
 *  @param aString 替换过含有如[em:02:]的字符串
 *
 *  @return 富文本String
 */
- (NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges
                                                      forString:(NSString*)aString{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:aString];
    helvetica = CTFontCreateWithName(CFSTR("Helvetica"),FontSize, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[attrString.string length])];
    
    [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(kUIColorFromRGB(0x666666).CGColor) range:NSMakeRange(0,[attrString.string length])];
    

    for (int i = 0; i < _attributedData.count; i ++) {
        
        NSString *str = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        if (!_textColor) {
            _textColor = [UIColor blueColor];
        }
        [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(_textColor.CGColor) range:NSRangeFromString(str)];
        
    }
    
    for(NSInteger i = 0; i < [ranges count]; i++){
        
        NSRange range = NSRangeFromString([ranges objectAtIndex:i]);
        NSString *emotionName = [self.emotionNames objectAtIndex:i];
        [attrString addAttribute:AttributedImageNameKey value:emotionName range:range];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)newEmotionRunDelegate() range:range];
    }
    
    return attrString;
}

// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key{
    
    NSString *nameStr = [NSString stringWithFormat:@"%@.png",key];
    return [UIImage imageNamed:nameStr];
}

CTRunDelegateRef newEmotionRunDelegate(){
    
    static NSString *emotionRunName = @"emotionRunName";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = WFRunDelegateDeallocCallback;
    imageCallbacks.getAscent = WFRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = WFRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = WFRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,
                                                       (__bridge void *)(emotionRunName));
    
    return runDelegate;
}

#pragma mark - Run delegate
void WFRunDelegateDeallocCallback( void* refCon ){
    // CFRelease(refCon);
}

CGFloat WFRunDelegateGetAscentCallback( void *refCon ){
    return FontHeight;
}

CGFloat WFRunDelegateGetDescentCallback(void *refCon){
    return 0.0;
}

CGFloat WFRunDelegateGetWidthCallback(void *refCon){
    // EmotionImageWidth + 2 * ImageLeftPadding
    return  19.0;
}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect{
    // 没有内容时取消本次绘制
    if (!typesetter)   return;
    
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    // 翻转坐标系
    Flip_Context(context, FontHeight);
    
    CGFloat y = -5;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK = 0;
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 5, y);
        
        // 画字
        CTLineDraw(line, context);
        
        // 画表情
        Draw_Emoji_For_Line(context, line, self, CGPointMake(0, y));
        
        start += count;
        y -= FontSize + LineSpacing;
        CFRelease(line);
        
        tempK ++;
        if (tempK == limitline) {
            _limitCharIndex = start;
            //  NSLog(@"limitCharIndex = %ld",self.limitCharIndex);
        }
    }
    
    UIGraphicsPopContext();
}

// 翻转坐标系 offset为字体的高度
static inline
void Flip_Context(CGContextRef context, CGFloat offset){
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -offset);
}

// 生成每个表情的 frame 坐标
static inline
CGPoint Emoji_Origin_For_Line(CTLineRef line, CGPoint lineOrigin, CTRunRef run){
    CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) + ImageLeftPadding;
    CGFloat y = lineOrigin.y - ImageTopPadding;
    return CGPointMake(x, y);
}


// 绘制每行中的表情
void Draw_Emoji_For_Line(CGContextRef context, CTLineRef line, id owner, CGPoint lineOrigin){
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    // 统计有多少个run
    NSUInteger count = CFArrayGetCount(runs);
    
    // 遍历查找表情run
    for(NSInteger i = 0; i < count; i++){
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(aRun);
        NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, AttributedImageNameKey);
        if (emojiName){
            // 画表情
            CGRect imageRect = CGRectZero;
            imageRect.origin = Emoji_Origin_For_Line(line, lineOrigin, aRun);
            imageRect.size = CGSizeMake(EmotionImageWidth, EmotionImageWidth);
            CGImageRef img = [[owner getEmotionForKey:emojiName] CGImage];
            CGContextDrawImage(context, imageRect, img);
        }
    }
}


- (CGFloat)getTextHeight{
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    CGFloat y = -5;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK = 0;
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= FontSize + LineSpacing;
        CFRelease(line);
        tempK++;
        if (tempK == limitline && _isFold == YES) {
            
            break;
        }
    }
    return -y;
}


#pragma mark - 获得行数
- (NSInteger)getTextLines{
    int textlines = 0;
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    CGFloat y = -5;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= FontSize + LineSpacing;
        CFRelease(line);
        
        textlines ++;
    }
    return textlines;
}

- (void)manageGesture:(UIGestureRecognizer *)gesture gestureType:(GestureType)gestureType{
    CGPoint point = [gesture locationInView:self];
    
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    CGFloat y = -5;
    CFIndex start = 0;
    NSInteger length = [_newString length];
    
    BOOL isSelected = NO;//判断是否点到selectedRange内 默认没点到
    
    while (start < length){
        
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGFloat ascent, descent;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        
        CGRect lineFrame = CGRectMake(0, -y, lineWidth, ascent + descent);
        
        if (CGRectContainsPoint(lineFrame, point)) { //没进此判断 说明没点到文字 ，点到了文字间距处
            
            CFIndex index = CTLineGetStringIndexForPosition(line, point);
            if ([self judgeIndexInSelectedRange:index withWorkLine:line] == YES) {//点到selectedRange内
                
                isSelected = YES;
                
            }else{
                //点在了文字上 但是不在selectedRange内
                
            }
        }
        start += count;
        y -= FontSize + LineSpacing;
        CFRelease(line);
    }
    
    if (isSelected == YES) {
        DELAYEXECUTE(0.3, [_selectionsViews makeObjectsPerformSelector:@selector(removeFromSuperview)];);
        return;
    }else{
        if (gestureType == TapGesType) {
            if (_canClickAll == YES) {
                [self clickAllContext];
            }else{
                
            }
        }else{
            if (_canClickAll == YES) {
                
                [self longClickAllContext];
                
            }else{
                
            }
        }
        return;
        
    }
    
    DELAYEXECUTE(0.3, [_selectionsViews makeObjectsPerformSelector:@selector(removeFromSuperview)]);
}

#pragma mark - 长按自己
- (void)longPressMyself:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self manageGesture:gesture gestureType:LongGesType];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeLongClickArea];
    }
}

#pragma mark -点击自己
- (void)tapMyself:(UITapGestureRecognizer *)gesture{
    [self manageGesture:gesture gestureType:TapGesType];
}

- (BOOL)judgeIndexInSelectedRange:(CFIndex) index withWorkLine:(CTLineRef)workctLine{
    for (int i = 0; i < _attributedData.count; i ++) {
        NSString *key = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        NSRange keyRange = NSRangeFromString(key);
        if (index>=keyRange.location && index<= keyRange.location + keyRange.length) {
            if (_isFold) {
                if ((_limitCharIndex > keyRange.location) && (_limitCharIndex < keyRange.location + keyRange.length)) {
                    
                    keyRange = NSMakeRange(keyRange.location, _limitCharIndex - keyRange.location);
                }
            }else{
                //Do nothing
            }
            NSMutableArray *arr = [self getSelectedCGRectWithClickRange:keyRange];
            [self drawViewFromRects:arr withDictValue:[[_attributedData objectAtIndex:i] valueForKey:key]];
            
            NSString *feedString = [[_attributedData objectAtIndex:i] valueForKey:key];
            [_delegate clickHFTextView:feedString];
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)getSelectedCGRectWithClickRange:(NSRange)tempRange{
    NSMutableArray *clickRects = [[NSMutableArray alloc] init];
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    CGFloat y = -5;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
        if (intersection.length > 0){
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            
            CGFloat ascent, descent;
            //,leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(xStart + 5, -y, xEnd -  xStart , ascent + descent + 2);//所画选择之后背景的 大小 和起始坐标 +5为增加起始点位置(绘图时增加了5的间距) +2为微调
            [clickRects addObject:NSStringFromCGRect(selectionRect)];
        }
        y -= FontSize + LineSpacing;
        CFRelease(line);
    }
    return clickRects;
}

//超出1行 处理
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location){
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location + first.length){
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }
    return result;
}


- (void)drawViewFromRects:(NSArray *)array withDictValue:(NSString *)value{
    //用户名可能超过1行的内容 所以记录在数组里，有多少元素 就有多少view
    // selectedViewLinesF = array.count;
    
    for (int i = 0; i < [array count]; i++) {
        UIView *selectedView = [[UIView alloc] init];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = kUserName_SelectedColor;
        selectedView.layer.cornerRadius = 4;
        [self addSubview:selectedView];
        [_selectionsViews addObject:selectedView];
    }
}


- (void)clickAllContext{
    if (self.allClickShowView) {
        UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        myselfSelected.tag = 10102;
        [self insertSubview:myselfSelected belowSubview:self];
        myselfSelected.backgroundColor = kSelf_SelectedColor;
    }
    [_delegate clickHFTextView:@""];
    
    DELAYEXECUTE(0.3, {
        if ([self viewWithTag:10102]) {
            [[self viewWithTag:10102] removeFromSuperview];
        }
    });
}

- (void)longClickAllContext{
    UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = kSelf_SelectedColor;
//    if (_replyIndex == -1) {
//        [_delegate longClickHFTextView:_oldString];
//    }else{
        [_delegate longClickHFTextView:@""];
//    }
    DELAYEXECUTE(0.3, {
        if ([self viewWithTag:10102]) {
            [[self viewWithTag:10102] removeFromSuperview];
        }
    });
}

- (void)removeLongClickArea{
    if ([self viewWithTag:10102]) {
        [[self viewWithTag:10102] removeFromSuperview];
    }
//    [WFHudView showMsg:@"复制成功" inView:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
