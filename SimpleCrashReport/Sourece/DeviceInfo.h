//
//  DeviceInfo.h
//  TestCrashReport
//
//  Created by 김승진 on 2017. 5. 8..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

-(NSString *) userTelephony; // 통신사, 국가코드
-(NSString *) userLocation; // 지역

-(NSString *) deviceInfomation; // device 정보
-(NSString *) deviceName; // device 이름

-(NSString *) userJailbroken; //탈옥 체크 여부

-(NSString *) debugTime; //디버그 발생 시간
-(NSString *) launchTime; //앱 실행 시간

@end
