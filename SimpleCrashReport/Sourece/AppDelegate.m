//
//  AppDelegate.m
//  TestCrashReport
//
//  Created by Administrator on 2017. 4. 7..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import "AppDelegate.h"

#import "KSCrash.h"
#import "KSCrashC.h"
#import "KSCrashInstallation+Alert.h"
#import "KSCrashInstallationStandard.h"
#import "KSCrashInstallationQuincyHockey.h"
#import "KSCrashInstallationEmail.h"
#import "KSCrashInstallationVictory.h"
#import "KSCrashInstallationConsole.h"

#import "KSCrashReportFilter.h"
#import "KSCrashReportFilterAppleFmt.h"
#import "KSCrashReportFilterBasic.h"
#import "KSCrashReportSinkConsole.h"

#import "USTLogger.h"
#import "UIApplication+EventAutomator.h"
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
    [self launchTime];//앱 실행 시간
    
    [self installCrashHandler];
    
    [[USTLogger sharedInstance] writeNSLogToFile];
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");

	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");

	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");

	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");

	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:@"EventLog.log"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:logFilePath]){
        [manager removeItemAtPath:logFilePath error:nil];
    }

	
}

- (void) installCrashHandler
{
	int reportCount = (int)[[KSCrash sharedInstance] reportCount];
    if(reportCount!=0){
        kscrash_deleteAllReports();
    }
    
	self.crashInstallation = [self makeConsoleInstallation];
	[self.crashInstallation install];
	[self configureAdvancedSettings];
}

- (KSCrashInstallationConsole*) makeConsoleInstallation
{
	KSCrashInstallationConsole* victory = [KSCrashInstallationConsole sharedInstance];
	victory.printAppleFormat=YES;
	return victory;
}

- (void) configureAdvancedSettings
{
	KSCrash* handler = [KSCrash sharedInstance];
	handler.deadlockWatchdogInterval = 8;
    handler.catchZombies = YES;

	handler.onCrashReport = crashReport_callback; // crashReport_callback를 읽어온다.

}

static void crashReport_callback(const char* path)
{
	KSCrash* crashReporter = [KSCrash sharedInstance];
    
    crashReporter.sink = (id<KSCrashReportFilter>)[KSCrashReportFilterPipeline filterWithFilters:
                                                   [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleUnsymbolicated],
                                                   nil];
    
	NSError *err = NULL;
	NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [dirPath objectAtIndex:0];
	
	NSString *filePath = [documentPath stringByAppendingString:@"/Test1.txt"];
	NSString *txtFileContents = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:path] encoding:NSUTF8StringEncoding error:NULL];
	[txtFileContents writeToFile:filePath atomically:FALSE encoding:NSUTF8StringEncoding error:&err];
	
    
	[crashReporter sendAllReportsWithCompletion:^(NSArray* reports1, BOOL completed, NSError* error1)
	 {
		 NSError *err = NULL;
		 if(completed)
		 {
			 NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			 NSString *documentPath = [dirPath objectAtIndex:0];
			 
			 NSString *strCrash = [documentPath stringByAppendingString:@"/CrashLog.crash"];
			 NSString *fileContent = [reports1 componentsJoinedByString: @"\n"];
             [fileContent writeToFile:strCrash atomically:FALSE encoding:NSUTF8StringEncoding error:&err];
		 }
		 else
		 {
			 NSLog(@"Failed to send reports: %@", error1);
		 }
	 }];
}

-(void)launchTime{
    //실행 시간
    NSDate *launchTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // GMT
    NSString *dateString = [dateFormat stringFromDate:launchTime];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dateString forKey:@"launchTime"];
}




@end
