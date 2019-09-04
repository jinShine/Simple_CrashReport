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
    if (reportCount!=0) {
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
	
    
	[crashReporter sendAllReportsWithCompletion:^(NSArray* reports1, BOOL completed, NSError* error1) {
		 NSError *err = NULL;
		 if(completed) {
			 NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			 NSString *documentPath = [dirPath objectAtIndex:0];
			 
			 NSString *strCrash = [documentPath stringByAppendingString:@"/CrashLog.crash"];
			 NSString *fileContent = [reports1 componentsJoinedByString: @"\n"];
             [fileContent writeToFile:strCrash atomically:FALSE encoding:NSUTF8StringEncoding error:&err];
		 }
		 else {
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
