//
//  DeviceInfo.m
//  TestCrashReport
//
//  Created by 김승진 on 2017. 5. 8..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import "DeviceInfo.h"
#import <sys/utsname.h> //deviceName
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

@implementation DeviceInfo


-(NSString *)debugTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

-(NSString *)launchTime{
    NSUserDefaults *defalut = [NSUserDefaults standardUserDefaults];
    NSString *launch = [defalut objectForKey:@"launchTime"];
    
    return launch;
}

- (NSString*) deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",        // (Original)
                              @"iPod2,1"   :@"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" :@"iPhone",            // (Original)
                              @"iPhone1,2" :@"iPhone",            // (3G)
                              @"iPhone2,1" :@"iPhone",            // (3GS)
                              @"iPad1,1"   :@"iPad",              // (Original)
                              @"iPad2,1"   :@"iPad 2",            //
                              @"iPad3,1"   :@"iPad",              // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",          // (GSM)
                              @"iPhone3,3" :@"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",         //
                              @"iPhone5,1" :@"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",              // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",         // (Original)
                              @"iPhone5,3" :@"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",     //
                              @"iPhone7,2" :@"iPhone 6",          //
                              @"iPhone8,1" :@"iPhone 6S",         //
                              @"iPhone8,2" :@"iPhone 6S Plus",    //
                              @"iPhone8,4" :@"iPhone SE",         //
                              @"iPhone9,1" :@"iPhone 7",          //
                              @"iPhone9,3" :@"iPhone 7",          //
                              @"iPhone9,2" :@"iPhone 7 Plus",     //
                              @"iPhone9,4" :@"iPhone 7 Plus",     //
                              
                              @"iPad4,1"   :@"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   :@"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   :@"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

-(NSString *)userTelephony{
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *carrierName = [carrier carrierName]; //통신사
    
    if([carrierName isEqualToString:[UIDevice currentDevice].model]){
        return [NSString stringWithFormat:@"통신사%@",@"-"];
    }else{
        return [NSString stringWithFormat:@"통신사%@",carrierName];
    }
    
}

-(NSString *)userLocation{
    NSString *countryCode = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
    return [NSString stringWithFormat:@"%@ ", countryCode];
}



-(NSString *)deviceInfomation{
    
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString *deviceName = [UIDevice currentDevice].name;
    //NSString *deviceModel = [UIDevice currentDevice].model;
    //NSString *deviceSystemName = [UIDevice currentDevice].systemName; // OS Name
    NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion; //OS Version
    //NSString *deviceOrientagion = [UIDevice currentDevice].orientation;
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"UUID : %@ / Model : %@ / Version : %@ / App Version : %@ / Identifier : %@ / 탈옥 상태 : %@ ", deviceUUID, [self deviceName],
            deviceSystemVersion, bundleVersion, bundleIdentifier, [self userJailbroken]];
    
}


-(NSString *)userJailbroken{
#if !(TARGET_IPHONE_SIMULATOR)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:@"/Applications/Cydia.app"]
        || [fileManager fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]
        || [fileManager fileExistsAtPath:@"/usr/sbin/sshd"]
        || [fileManager fileExistsAtPath:@"/etc/apt"]
        || [fileManager fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        return @"탈옥";
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        //Device is jailbroken
        return @"탈옥";
    }
#endif
    
    return @"탈옥 아님";
}

@end
