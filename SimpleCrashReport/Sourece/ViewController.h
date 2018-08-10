//
//  ViewController.h
//  TestCrashReport
//
//  Created by Administrator on 2017. 4. 7..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// 예상되는 Crash 오류 버튼들
- (IBAction) onCrash : (id) sender;
- (IBAction) onCrash2: (id) sender;
- (IBAction) onCrash3: (id) sender;

- (void)sendAlertView;

@end

