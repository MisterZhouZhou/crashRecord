# crashRecord
记录崩溃日志的demo
***
ZWCrashRecordTool默认将crash保存在系统Caches/crash目录下，也可以自定义保存目录。

ZWCrashRecordTool添加功能：

  * 记录crash
  * 清除crash缓存
  
***
  **<h3>使用方法</h3>**
  
  **<h4>1、初始化方法</h4>**
  在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中加入
  
  method1: 
  	  
	[[ZWCrashRecordTool shareInstance]installUncaughtExceptionHandlerWithPath:nil];

methdo2:

    NSString *filePath  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
	[[ZWCrashRecordTool shareInstance]installUncaughtExceptionHandlerWithPath:filePath];
	
**<h4>2、清除缓存</H4>**

	//清除缓存
    [[ZWCrashRecordTool shareInstance] clearCache];
    
**<h3> 缓存记录图：</h3>**

 ![](https://github.com/MisterZhouZhou/crashRecord/blob/master/images/crash.png)
