//
//  ZWCrashRecordTool.h
//  获取程序的crash日志
//
//  Created by rayootech on 16/7/6.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZWCrashRecordTool : NSObject

/* 缓存路径 */
@property(nonatomic,copy) NSString * crashPath;

+ (instancetype)shareInstance;

/**
 *  初始化缓存目录
 *
 *  @param crashPath 缓存目录
 */
-(void)installUncaughtExceptionHandlerWithPath:(NSString *)crashPath;

/**
 *  清除缓存日志
 */
-(void)clearCache;

@end
