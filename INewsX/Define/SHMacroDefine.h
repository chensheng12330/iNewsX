//
//  SHMacroDefine.h
//  TestFrame
//
//  Created by sherwin.chen on 13-6-15.
//  Copyright (c) 2013年 sherwin.chen. All rights reserved.
//

#ifndef SHMacroDefine
#define SHMacroDefine

#define NavigationBar_HEIGHT 44

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SH_IOS7_SET {if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {\
                          self.edgesForExtendedLayout = UIRectEdgeNone;}}

#define SH_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SH_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SH_SAFE_RELEASE(x) [x release];x=nil
#define SH_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SH_CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define SH_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define SH_BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

#define SH_CLEARCOLOR [UIColor clearColor]
#define SCH_Gre [UIColor colorWithRed:67/255.0 green:196/255.0 blue:8/255.0 alpha:1]


#define SHAlert(info)  [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:info delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil] show];

#define SHAlertEx(title,info)  [[[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] autorelease] show];

#define SHServerFailure [self showHint:@"网络连接失败，请检查您的手机网络."];

//devices
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height >= 568)
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_IS_IPAD     ([[UIScreen mainScreen] bounds].size.width > 320)

#define DEVICE_Version_Value [[[UIDevice currentDevice] systemVersion] floatValue]
#define DEVICE_IS_IOS7 ((DEVICE_Version_Value>=7.0)&&(DEVICE_Version_Value)<8.0)
#define DEVICE_IS_IOS8 ((DEVICE_Version_Value>=8.0)&&(DEVICE_Version_Value)<9.0)

#define DEVICE_IS_480IOS7 (SH_SCREEN_HEIGHT==480 && DEVICE_IS_IOS7)

#define DEVICE_RightDrawerWidth (DEVICE_IS_IPAD?SH_SCREEN_WIDTH:SH_SCREEN_WIDTH-70)
//#define DEVICE_IS_IPAD ()
//#if !TARGET_OS_IPHONE || __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
//file dir
#define SH_LibraryDir ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define SH_FileMag ([NSFileManager defaultManager])
#define SH_APP ([UIApplication sharedApplication])
//#define SH_Window ([[UIApplication sharedApplication].windows lastObject])
#define SH_Window ([UIApplication sharedApplication].keyWindow)
#define SH_loadNibName(name,target) [[[NSBundle mainBundle] loadNibNamed:name owner:target options:nil] firstObject];
#define SH_BundlePath(name,type) [[NSBundle mainBundle] pathForResource:name ofType:type]


//use JS Function Interaction
#define JSDebugAlert(info) {UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"JS调试出错!" message:info delegate:nil cancelButtonTitle:@"马上修改" otherButtonTitles:nil];\
[alert show];[alert release];}

#define JSGetArgmForNumber(argument) ([argument isKindOfClass:[NSNumber class]] ? argument:[argument isKindOfClass:[NSString class]]?[NSNumber numberWithDouble:[argument doubleValue]]:NULL)
#define JSGetArgmForString(argument) ([argument isKindOfClass:[NSString class]] ? argument:[argument isKindOfClass:[NSNumber class]]?[argument stringValue]:NULL)

//exception info
#define SHExcpInfo(xx, ...) [NSString stringWithFormat:@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#define SHExcp(er_lvl,er_info) ([NSException exceptionWithName:er_lvl reason: SHExcpInfo(@"内部异常: %@",er_info) userInfo:nil])

#define SH_isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define SH_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


//方正黑体简体字体定义
//#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//安全删除对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//文件管理
//缓存目录
#define SH_DefaultCaches  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
#define SH_DefaultFileManager              [NSFileManager defaultManager]

//判断类是否可用
#define SH_USABLE_CLASS(a)    ([UICollectionView class]==NULL?FALSE:TRUE)
#define SH_USABLE_SELECTOR(c,s) ([c instancesRespondToSelector:s]==NULL?FALSE:TRUE)

///字符串NULL处理
#define StringNULL(string) (string==NULL?@"":string)
#define SH_StringIsNULL(stringT) ([stringT isKindOfClass:[NSNull class]] || (stringT.length<1))

//iphonex 适配
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

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define hasIPhoneX4ViewOffset (iPhoneX?22:0)
//--------------------------------------------------


//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


#define SH_USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define SH_ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


#pragma mark - degrees/radian functions
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]



// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}
#endif

/////////集成ISeePlus过的宏
//判断设备类型
#define IS_IPHONE5_BEFORE ([UIScreen mainScreen].bounds.size.width==320.0f)?YES:NO
#define IS_IPHONE6 ([UIScreen mainScreen].bounds.size.width==375.0f)?YES:NO
#define IS_IPHONE6PLUS ([UIScreen mainScreen].bounds.size.width==414.0f)?YES:NO
#define IS_IPAD ([UIScreen mainScreen].bounds.size.width==768.0f)?YES:NO

//屏幕大小
//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif


//导航栏主颜色
#define AS_COLOR_NAVI [UIColor colorWithRed:0.988 green:0.518 blue:0.157 alpha:1.000]

//按钮主颜色
#define AS_COLOR_MAINBTN [UIColor colorWithRed:0.875 green:0.188 blue:0.212 alpha:1.000]
//按钮主颜色高亮
#define AS_COLOR_MAINBTN_LIGHT [UIColor colorWithRed:0.667 green:0.150 blue:0.169 alpha:1.000]


//APP版本号获取
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//消息间隔时间
#define CHAT_MSG_TIME 60.0


//
//  YYKitMacro.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/3/29.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>
#import <pthread.h>

#ifndef YYKitMacro_h
#define YYKitMacro_h

#ifdef __cplusplus
#define YY_EXTERN_C_BEGIN  extern "C" {
#define YY_EXTERN_C_END  }
#else
#define YY_EXTERN_C_BEGIN
#define YY_EXTERN_C_END
#endif


YY_EXTERN_C_BEGIN

#ifndef YY_CLAMP // return the clamped value
#define YY_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef YY_SWAP // swap two value
#define YY_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


#define YYAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define YYCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define YYAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define YYCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define YYAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define YYCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 YYSYNTH_DUMMY_CLASS(NSString_YYAdd)
 */
#ifndef YYSYNTH_DUMMY_CLASS
#define YYSYNTH_DUMMY_CLASS(_name_) \
@interface YYSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation YYSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YYSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef YYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define YYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YYSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef YYSYNTH_DYNAMIC_PROPERTY_CTYPE
#define YYSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
static inline NSRange YYNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
static inline CFRange YYCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

/**
 Same as CFAutorelease(), compatible for iOS6
 @param arg CFObject @return same as input
 */
static inline CFTypeRef YYCFAutorelease(CFTypeRef CF_RELEASES_ARGUMENT arg) {
    if (((long)CFAutorelease + 1) != 1) {
        return CFAutorelease(arg);
    } else {
        id __autoreleasing obj = CFBridgingRelease(arg);
        return (__bridge CFTypeRef)obj;
    }
}

/**
 Profile time cost.
 @param ^block     code to benchmark
 @param ^complete  code time cost (millisecond)
 
 Usage:
 YYBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog("time cost: %.2f ms",ms);
 });
 
 */
static inline void YYBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

static inline NSDate *_YYCompileTime(const char *data, const char *time) {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",data,time];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 Get compile timestamp.
 @return A new date object set to the compile date and time.
 */
#ifndef YYCompileTime
// use macro to avoid compile warning when use pch file
#define YYCompileTime() _YYCompileTime(__DATE__, __TIME__)
#endif

/**
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
static inline dispatch_time_t dispatch_walltime_delay(NSTimeInterval second) {
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 */
static inline dispatch_time_t dispatch_walltime_date(NSDate *date) {
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

/**
 Whether in main queue/thread.
 */
static inline bool dispatch_is_main_queue() {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 Initialize a pthread mutex.
 */
static inline void pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive) {
#define YYMUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive) {
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    } else {
        pthread_mutexattr_t attr;
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr));
    }
#undef YYMUTEX_ASSERT_ON_ERROR
}


YY_EXTERN_C_END
#endif

