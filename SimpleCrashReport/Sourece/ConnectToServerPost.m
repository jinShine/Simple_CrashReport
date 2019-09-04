//
//  ConnectToServerPost.m
//  TestCrashReport
//
//  Created by 김승진 on 2017. 4. 12..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import "ConnectToServerPost.h"
#import "DeviceInfo.h"

DeviceInfo *device = nil;

@implementation ConnectToServerPost


-(NSString *)crashLogFilePath {
    //해당파일 파일 경로를 읽어들여옴
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog.crash"];

    return crashLogPath;
}

- (void) uploadToCrashLogCollecter {

    //해당파일 파일 경로를 읽어들여옴
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog.crash"];
    
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:crashLogPath];
    
    NSString *urlString =[NSString stringWithFormat:@"https://stalpapartners.startsupport.com/LogCollect/svc/content/collect.aspx"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"------------123qouQielKSOS45678910";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //param
    NSString *ExtAddress = [self addressJsonDataPhasing];
    NSString *ExtNumber	= @"-";
    NSString *ErrInfo	 = [self crashJsonDataPhasing];
    NSString *UserName = @"-";
    NSString *UserTel	 = @"-";
    NSString *UserEmail = @"-";
    NSString *Content;
    
    if(device == nil){
        device = [[DeviceInfo alloc]init];
        Content	 = [NSString stringWithFormat:@"%@\r\n / 지역 : %@ / %@ / Launch Time : %@ / Debug Time : %@",
                    [device userTelephony],
                    [device userLocation],
                    [device deviceInfomation],
                    [device launchTime],
                    [device debugTime]];
    }
    
    NSString *ProductType = @"RV";
    
    NSDictionary *params = @{@"ExtAddress" : ExtAddress,
                             @"ExtNumber" : ExtNumber,
                             @"ErrInfo" : ErrInfo,
                             @"UserName" : UserName,
                             @"UserTel" : UserTel,
                             @"UserEmail" : UserEmail,
                             @"Content" : Content,
                             @"ProductType" : ProductType};
    
    
    NSMutableData *body = [NSMutableData data];
    
    for(NSString *param in params){
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey: param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //boundary
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ErrFile\"; filename=\"%@.crash\"\r\n", @"Crash"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
}

-(void) uploadToLogReport {
    
    //해당파일 파일 경로를 읽어들여옴
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"EventLog.log"];
    
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:crashLogPath];
    
    //https://stalpapartners.startsupport.com/LogReport/svc/content/collect.aspx
    //서버 주소를 넣어주세요
    NSString *urlString =[NSString stringWithFormat:@"여기에 주소를 넣어주세요."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"------------123qouQielKSOS45678910";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //param
    NSString *UserName = @"-";
    NSString *UserTel	 = @"-";
    NSString *UserEmail = @"-";
    NSString *Title = @"Logfile";
    NSString *Content;
    
    device = [[DeviceInfo alloc]init];
    Content	 = [NSString stringWithFormat:@"%@\r\n / 지역 : %@ / %@ / Launch Time : %@ / Debug Time : %@",
                [device userTelephony],
                [device userLocation],
                [device deviceInfomation],
                [device launchTime],
                [device debugTime]];
    
    
    NSString *ProductType	 = @"RV";
    NSDictionary *params = @{@"UserName" : UserName,
                             @"UserTel" : UserTel,
                             @"UserEmail" : UserEmail,
                             @"Title" : Title,
                             @"Content" : Content,
                             @"ProductType" : ProductType};
    
    
    NSMutableData *body = [NSMutableData data];
    
    for(NSString *param in params){
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey: param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LogFile\"; filename=\"%@.log\"\r\n", @"LogFile"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
}

-(NSString *)addressJsonDataPhasing{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"Test1.txt"];
    
    NSString *contentFile = [NSString stringWithContentsOfFile:crashLogPath encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"data : %@",contentFile);
    
    NSData *jsonData = [contentFile dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:2 error:nil];
    
    
    NSDictionary *crashDic = [jsonDic objectForKey:@"crash"];
    NSArray *threadsArr = [crashDic objectForKey:@"threads"];
    NSDictionary *threadsDic = [threadsArr objectAtIndex:0];
    
    NSDictionary *backtraceDic = [threadsDic objectForKey:@"backtrace"];
    NSArray *contentsArr = [backtraceDic objectForKey:@"contents"];
    
    
    NSDictionary *symbolnameDic = [contentsArr objectAtIndex:0];
    
    
    NSString *objectName = [symbolnameDic objectForKey:@"object_name"];
    NSString *symbolAddr = [symbolnameDic objectForKey:@"symbol_addr"];
    int i = 1;
    while (![objectName isEqualToString:[self extraAppName]]) {
        symbolnameDic = [contentsArr objectAtIndex:i];
        objectName = [symbolnameDic objectForKey:@"object_name"];
        symbolAddr = [symbolnameDic objectForKey:@"symbol_addr"];
        i++;
    }
    
    //NSLog(@"data : %@ , %@",objectName,symbolName);
    
    return symbolAddr;
}

-(NSString *)numberJsonDataPhasing{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"Test1.txt"];
    
    NSString *contentFile = [NSString stringWithContentsOfFile:crashLogPath encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"data : %@",contentFile);
    
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

    return symbolName;
}


-(NSString *)crashJsonDataPhasing{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *crashLogPath = [documentsDirectory stringByAppendingPathComponent:@"Test1.txt"];
    
    NSString *contentFile = [NSString stringWithContentsOfFile:crashLogPath encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"data : %@",contentFile);
    
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
    
    //NSLog(@"data : %@ , %@",objectName,symbolName);
    
    return symbolName;
}


//앱의 이름 추출
-(NSString *)extraAppName{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [infoDic objectForKey:@"CFBundleName"];
    
    return appName;
}



@end
