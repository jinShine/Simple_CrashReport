//
//  AppDelegate.h
//  TestCrashReport
//
//  Created by Administrator on 2017. 4. 7..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KSCrashInstallation;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KSCrashInstallation* crashInstallation;


@end

