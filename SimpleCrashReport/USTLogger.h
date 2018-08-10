//
//  USTLogger.h
//  USTLoggerSample
//
//  Created by Uma Shanker Tiwari on 09/06/15.
//  Copyright (c) 2015 Uma Shanker Tiwari. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface USTLogger : NSObject
{
    BOOL stdErrRedirected;
    
}
@property (nonatomic, assign) BOOL stdErrRedirected;

-(void) writeNSLogToFile;

+ (USTLogger *) sharedInstance;

@end
