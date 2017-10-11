//
//  MGNetworkStatusObserver.m
//  MGNetWorkStatusObserver
//
//  Created by MR_THT on 2017/10/10.
//

#import "MGNetworkStatusObserver.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface MGNetworkStatusObserver ()
/** 2G数组 */
@property (nonatomic,strong) NSArray *technology2GArray;
/** 3G数组 */
@property (nonatomic,strong) NSArray *technology3GArray;
/** 4G数组 */
@property (nonatomic,strong) NSArray *technology4GArray;
/** 网络状态中文数组 */
@property (nonatomic,strong) NSArray *coreNetworkStatusStringArray;
@property (nonatomic,strong) MGReachability *reachability;
@property (nonatomic,strong) CTTelephonyNetworkInfo *telephonyNetworkInfo;
@property (nonatomic,copy)   NSString *currentRaioAccess;
/** 是否正在监听 */
@property (nonatomic,assign) BOOL isNoti;
@property (nonatomic,assign) MGCoreNetWorkStatus oldNetworkStatus;
@end

#pragma mark - 初始化
static MGNetworkStatusObserver* MGGlobalCoreStatusInstance = nil;

@implementation MGNetworkStatusObserver

+(instancetype)shareInstance
{
    static dispatch_once_t NetworkStatus;
    dispatch_once(&NetworkStatus, ^{
        MGGlobalCoreStatusInstance = [[MGNetworkStatusObserver alloc]init];
    });
    
    return MGGlobalCoreStatusInstance;
}

//在 MGNetworkStatusObserver 第一次实例化时初始化该类
+(void)initialize
{
    MGNetworkStatusObserver *status = [MGNetworkStatusObserver shareInstance];
    status.telephonyNetworkInfo =  [[CTTelephonyNetworkInfo alloc] init];
}

/** 获取当前网络状态：枚举 */
+(MGCoreNetWorkStatus)currentNetWorkStatus
{
    MGNetworkStatusObserver *status = [MGNetworkStatusObserver shareInstance];
    return [status statusWithRadioAccessTechnology];
}

/** 获取当前网络状态：字符串 */
+(NSString *)currentNetWorkStatusString
{
    MGNetworkStatusObserver *status = [MGNetworkStatusObserver shareInstance];
    return status.coreNetworkStatusStringArray[[self currentNetWorkStatus]];
}

/** 开始网络监听 */
+(void)beginNotiNetwork:(id<MGCoreStatusProtocol>)listener
{
    MGNetworkStatusObserver *status = [MGNetworkStatusObserver shareInstance];
    
    if(status.isNoti){
        NSLog(@"CoreStatus已经处于监听中，请检查其他页面是否关闭监听！");
        [self endNotiNetwork:(id<MGCoreStatusProtocol>)listener];
    }
    
    //注册监听
    [[NSNotificationCenter defaultCenter] addObserver:listener
                                             selector:@selector(coreNetworkChangeNoti:)
                                                 name:MGCoreStatusChangedNoti
                                               object:status];
    [[NSNotificationCenter defaultCenter] addObserver:status
                                             selector:@selector(coreNetWorkStatusChanged:)
                                                 name:MGReachabilityChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:status
                                             selector:@selector(coreNetWorkStatusChanged:)
                                                 name:CTRadioAccessTechnologyDidChangeNotification
                                               object:nil];
    [status.reachability startNotifier];
    //标记
    status.isNoti = YES;
}

/** 停止网络监听 */
+(void)endNotiNetwork:(id<MGCoreStatusProtocol>)listener
{
    MGNetworkStatusObserver *status = [MGNetworkStatusObserver shareInstance];
    
    if(!status.isNoti){
        NSLog(@"CoreStatus监听已经被关闭");
        return;
    }
    
    //解除监听
    [[NSNotificationCenter defaultCenter] removeObserver:status
                                                    name:MGReachabilityChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:status
                                                    name:CTRadioAccessTechnologyDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:listener
                                                    name:MGCoreStatusChangedNoti
                                                  object:status];
    //标记
    status.isNoti = NO;
}

/** 是否是Wifi */
+(BOOL)isWifiEnable
{
    return [self currentNetWorkStatus] == CoreNetWorkStatusWifi;
}

/** 是否有网络 */
+(BOOL)isNetworkEnable
{
    MGCoreNetWorkStatus networkStatus = [self currentNetWorkStatus];
    
    return networkStatus != CoreNetWorkStatusUnkhow &&
    networkStatus != CoreNetWorkStatusNone;
}

/** 是否处于高速网络环境：3G、4G、Wifi */
+(BOOL)isHighSpeedNetwork
{
    MGCoreNetWorkStatus networkStatus = [self currentNetWorkStatus];
    
    return  networkStatus == CoreNetWorkStatus3G ||
    networkStatus == CoreNetWorkStatus4G ||
    networkStatus == CoreNetWorkStatusWifi;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reachability = [MGReachability reachabilityForInternetConnection];
        self.oldNetworkStatus = CoreNetWorkStatusUnkhow;
    }
    return self;
}

- (void)coreNetWorkStatusChanged:(NSNotification *)notification
{
    //发送通知
    if (notification.name == CTRadioAccessTechnologyDidChangeNotification &&
        notification.object != nil) {
        self.currentRaioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    MGCoreNetWorkStatus status = [MGNetworkStatusObserver currentNetWorkStatus];
    
    //再次发出通知
    NSDictionary *userInfo = @{@"currentStatusEnum":@(status),
                               @"currentStatusString":[MGNetworkStatusObserver currentNetWorkStatusString],
                               @"oldStatusEnum":@(self.oldNetworkStatus)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MGCoreStatusChangedNoti
                                                        object:self
                                                      userInfo:userInfo];
    self.oldNetworkStatus = status;
}

- (MGCoreNetWorkStatus)statusWithRadioAccessTechnology
{
    MGCoreNetWorkStatus status = (MGCoreNetWorkStatus)[self.reachability currentReachabilityStatus];
    
    NSString *technology = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    
    if (status == CoreNetWorkStatusWWAN && technology != nil) {
        if ([self.technology2GArray containsObject:technology]){
            status = CoreNetWorkStatus2G;
        }
        else if ([self.technology3GArray containsObject:technology]){
            status = CoreNetWorkStatus3G;
        }
        else if ([self.technology4GArray containsObject:technology]){
            status = CoreNetWorkStatus4G;
        }
    }
    
    return status;
}

#pragma mark - 属性方法
/** 2G数组 */
-(NSArray *)technology2GArray
{
    @synchronized(_technology2GArray){
        if(_technology2GArray == nil){
            _technology2GArray = @[CTRadioAccessTechnologyEdge,
                                   CTRadioAccessTechnologyGPRS];
        }
    }
    
    return _technology2GArray;
}

/** 3G数组 */
-(NSArray *)technology3GArray
{
    @synchronized(_technology3GArray){
        if(_technology3GArray == nil){
            _technology3GArray = @[CTRadioAccessTechnologyHSDPA,
                                   CTRadioAccessTechnologyWCDMA,
                                   CTRadioAccessTechnologyHSUPA,
                                   CTRadioAccessTechnologyCDMA1x,
                                   CTRadioAccessTechnologyCDMAEVDORev0,
                                   CTRadioAccessTechnologyCDMAEVDORevA,
                                   CTRadioAccessTechnologyCDMAEVDORevB,
                                   CTRadioAccessTechnologyeHRPD];
        }
    }
    
    return _technology3GArray;
}

/** 4G数组 */
-(NSArray *)technology4GArray
{
    @synchronized(_technology4GArray){
        if(_technology4GArray == nil){
            
            _technology4GArray = @[CTRadioAccessTechnologyLTE];
        }
    }
    
    return _technology4GArray;
}

/** 网络状态中文数组 */
-(NSArray *)coreNetworkStatusStringArray
{
    @synchronized(_coreNetworkStatusStringArray){
        if(_coreNetworkStatusStringArray == nil){
            _coreNetworkStatusStringArray = @[@"Nonet",
                                              @"Wifi",
                                              @"cellular",
                                              @"2G",
                                              @"3G",
                                              @"4G",
                                              @"UnKnown"];
        }
    }
    
    return _coreNetworkStatusStringArray;
}

@end
