//
//  MGNetworkStatusObserver.h
//  MGNetWorkStatusObserver
//
//  Created by MR_THT on 2017/10/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGReachability.h"

#pragma mark - 网状态状枚举

/** 网络状态 */
typedef enum{
    /** 无网络 */
    CoreNetWorkStatusNone=0,
    /** Wifi网络 */
    CoreNetWorkStatusWifi,
    /** 蜂窝网络 */
    CoreNetWorkStatusWWAN,
    /** 2G网络 */
    CoreNetWorkStatus2G,
    /** 3G网络 */
    CoreNetWorkStatus3G,
    /** 4G网络 */
    CoreNetWorkStatus4G,
    //未知网络
    CoreNetWorkStatusUnkhow
} MGCoreNetWorkStatus;

#pragma mark - 网状状态侦听器
@protocol MGCoreStatusProtocol <NSObject>
@optional
/**
 *  当网络状态变更时的 NSNotifition 接收者。
 *  noti 参数的 name 属性等于 CoreStatusChangedNoti 常量
 *  noti 参数的 object 属性为 MGNetworkStatusObserver 实例对象
 *  noti 参数的 userinfo 属性是一个字典，包含以下成员：
 *       currentStatusEnum: 当前网络状态枚举值（MGCoreNetWorkStatus）
 *       currentStatusString: 当前网络类型的字符串值，比如：“WIFI”,"3G"
 *       oldStatusEnum: 先前的网络状态
 *
 *  @param noti NSNotification 对象
 */
-(void)coreNetworkChangeNoti:(NSNotification *)noti;
@end

/*
 控制器要获取当前网络状态：
 *  #import "MGNetworkStatusObserver.h"
 *  执行[CoreStatus currentNetWorkStatusString]返回状态字符串，或[CoreStatus currentNetWorkStatus]返回状态枚举
 
 网络状态改变后执行的方法：-(void)coreNetworkChangeNoti:(NSNotification *)noti;
 *  控制器遵守<MGCoreStatusProtocol>协议,成为一个listener,在需要时开启和关闭监听，成对出现！
 *  当网络状态变更时的 NSNotifition 接收者。
 *  noti 参数的 name 属性等于 MGCoreStatusChangedNoti 常量
 *  noti 参数的 object 属性为 MGNetworkStatusObserver 实例对象
 *  noti 参数的 userinfo 属性是一个字典，包含以下成员：
 *       currentStatusEnum: 当前网络状态枚举值（MGCoreNetWorkStatus）
 *       currentStatusString: 当前网络类型的字符串值，比如：“WIFI”,"3G"等
 *  @param noti NSNotification 对象
 */

//noti 参数的 name 常量
#define MGCoreStatusChangedNoti @"MGCoreStatusChangedNoti"


@interface MGNetworkStatusObserver : NSObject

/** 获取当前网络状态：枚举 */
+(MGCoreNetWorkStatus)currentNetWorkStatus;

/** 获取当前网络状态：字符串 */
+(NSString *)currentNetWorkStatusString;

/**
 *  注册网络状态改变事件通知
 *  如果在需要监听网络状态改变则必须使用 endNotiNetwork 方法结束监听，否则可能引起程序异常。
 
 *  @param listener 监听器实例
 */
+(void)beginNotiNetwork:(id<MGCoreStatusProtocol>)listener;

/** 停止网络监听
 *  结束监听后调用
 
 *  @param listener 监听器实例
 */
+(void)endNotiNetwork:(id<MGCoreStatusProtocol>)listener;

/** 是否是Wifi */
+(BOOL)isWifiEnable;

/** 是否有网络 */
+(BOOL)isNetworkEnable;

/** 是否处于高速网络环境：3G、4G、Wifi */
+(BOOL)isHighSpeedNetwork;

@end
