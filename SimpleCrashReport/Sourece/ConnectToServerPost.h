//
//  ConnectToServerPost.h
//  TestCrashReport
//
//  Created by 김승진 on 2017. 4. 12..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectToServerPost : NSObject

-(NSString *)crashLogFilePath;
-(void) uploadToCrashLogCollecter;
-(void) uploadToLogReport;


@end
