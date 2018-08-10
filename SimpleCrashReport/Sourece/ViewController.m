//
//  ViewController.m
//  TestCrashReport
//
//  Created by Administrator on 2017. 4. 7..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import "ViewController.h"
#import "ConnectToServerPost.h"
#import "DeviceInfo.h"

static ConnectToServerPost *connect = nil;
static DeviceInfo *deviceInfo = nil;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self supportedInterfaceOrientations];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog.crash"];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:@"EventLog.log"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if([manager fileExistsAtPath:crashLogPath] && [manager fileExistsAtPath:logFilePath]){
        [self sendAlertView];
    }
    
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

//메모리 비정장 접근 [SIGBUS]
- (IBAction) onCrash:(id) sender
{
	NSLog(@"Test");
	char* invalid = (char*)-1;
	*invalid = 1;
}

- (IBAction)onCrash2:(id)sender {
    //strcpy(0, "bla");
}

//Array out of Bound [SIGABORT]
- (IBAction)onCrash3:(id)sender {
    NSArray * array = [NSArray array];
    [array objectAtIndex:5];
}


-(void)sendAlertView{
    
    connect = [[ConnectToServerPost alloc]init];
    deviceInfo = [[DeviceInfo alloc]init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Crash Detection" message:[NSString stringWithFormat:@"%@\n Crash가 탐지 되었습니다.\n오류를 보내시겠습니까?",[deviceInfo debugTime]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [connect uploadToCrashLogCollecter];
        [connect uploadToLogReport];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog.crash"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if([manager fileExistsAtPath:crashLogPath]){
            [manager removeItemAtPath:crashLogPath error:nil];
            NSLog(@"파일 삭제 성공");
        }
        else{
            NSLog(@"파일 삭제 실패");
        }
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog.crash"];
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:@"EventLog.log"];
        NSLog(@"logFilePath : %@", logFilePath);
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if([manager fileExistsAtPath:crashLogPath] && [manager fileExistsAtPath:logFilePath]){
            [manager removeItemAtPath:crashLogPath error:nil];
            [manager removeItemAtPath:logFilePath error:nil];
            NSLog(@"파일 삭제 성공");
        }
        else{
            NSLog(@"파일 삭제 실패");
        }
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(NSString *)jsonDataPhasing{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"Test1.txt"];
    NSString *contentFile = [NSString stringWithContentsOfFile:crashLogPath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [contentFile dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:2 error:nil];
    
    
    NSDictionary *crashDic = [jsonDic objectForKey:@"crash"];
    NSArray *threadsArr = [crashDic objectForKey:@"threads"];
    NSDictionary *threadsDic = [threadsArr objectAtIndex:0];
    NSDictionary *backtraceDic = [threadsDic objectForKey:@"backtrace"];
    NSArray *contentsArr = [backtraceDic objectForKey:@"contents"];
    

    NSDictionary *symbolnameDic = [contentsArr objectAtIndex:0];

    NSString *objectName = [symbolnameDic objectForKey:@"object_name"];
    NSString *symbolName = [symbolnameDic objectForKey:@"symbol_name"];
    
    int i = 1;
    while (![objectName isEqualToString:[self extraAppName]]) {
        symbolnameDic = [contentsArr objectAtIndex:i];
        objectName = [symbolnameDic objectForKey:@"object_name"];
        symbolName = [symbolnameDic objectForKey:@"symbol_name"];
        i++;
    }

    NSString *errorInfo = [NSString stringWithFormat:@"TestName : %@\n  ErrorInfo : %@",objectName, symbolName];
    return errorInfo;
}

-(NSString *)extraAppName{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [infoDic objectForKey:@"CFBundleName"];
    
    return appName;
}

@end
