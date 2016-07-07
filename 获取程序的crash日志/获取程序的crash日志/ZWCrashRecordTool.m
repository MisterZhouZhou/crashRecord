//
//  ZWCrashRecordTool.m
//  获取程序的crash日志
//
//  Created by rayootech on 16/7/6.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "ZWCrashRecordTool.h"
#import <UIKit/UIKit.h>
@interface ZWCrashRecordTool()

@end

@implementation ZWCrashRecordTool

+ (instancetype)shareInstance;
{
    static ZWCrashRecordTool *instance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZWCrashRecordTool alloc] init];
        //日志存储路径,默认路径
        NSString *filePath  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        instance.crashPath = filePath;
    });
    return instance;
}

#pragma mark - 记录crash日志
-(void)installUncaughtExceptionHandlerWithPath:(NSString *)crashPath
{
    if (crashPath) self.crashPath = crashPath;
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

#pragma mark - 世界时间转换为本地时间
NSDate * worldDateToLocalDate(NSDate *date)
{
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [date dateByAddingTimeInterval:offset];
    return localDate;
}

#pragma mark - 获取crash文件名
NSString* getCrashFileName()
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat       = @"yyyyMMddHHmmss";
    fmt.timeZone         = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSDate *date         = [NSDate date];
    date                 = worldDateToLocalDate(date);
    NSString *dateString = [fmt stringFromDate:date];
    return dateString;
}

#pragma mark - getCrashPath(获取crash目录)
NSString * getCrashPath()
{
    return [[ZWCrashRecordTool shareInstance].crashPath stringByAppendingPathComponent:@"crash"];
}

#pragma mark - getCrashPath(获取crash详细路径)
NSString * getCrashAllPath()
{
    //路径
    NSString *path = getCrashPath();
    //crash文件名
    NSString *crashDate = getCrashFileName();
    return [NSString stringWithFormat:@"%@/%@.crash",path,crashDate];
}

#pragma mark - 创建文件
void  createCrashFile(NSString*usrStr)
{
    //创建crash目录
    BOOL isOK  = [[NSFileManager defaultManager]createFileAtPath:getCrashAllPath() contents:[usrStr dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (isOK) {
        NSLog(@"文件写入成功");
    }
}

#pragma mark - 设置缓存格式
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr   = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    
    NSString *usrStr = [NSString stringWithFormat:@"\n\n\n""错误详情(%@):\n%@\n------------崩溃原因----------\n%@\n-----------崩溃明细-----------\n%@",currentVersion,name,reason,[arr componentsJoinedByString:@"\n"]];
   
    //设置crash文件名
    NSLog(@"filePath==>%@\n",getCrashAllPath());
    //判断文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:getCrashPath()]) {//如果文件不存在则创建
        if([[NSFileManager defaultManager] createDirectoryAtPath:getCrashPath() withIntermediateDirectories:YES attributes:nil error:nil]){
            //写入文件
            createCrashFile(usrStr);
        }
    }
    else{
         //写入文件
         createCrashFile(usrStr);
    }
}



/////////////////////////////////////////////////////////////////////
#pragma mark - 清除缓存
-(void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:getCrashPath()];
    if (fileExists){
        BOOL success = [fileManager removeItemAtPath:getCrashPath() error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }

}

@end
