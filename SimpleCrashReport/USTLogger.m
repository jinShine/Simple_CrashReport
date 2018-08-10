//
//  USTLogger.m
//  USTLoggerSample
//
//  Created by Uma Shanker Tiwari on 09/06/15.
//  Copyright (c) 2015 Uma Shanker Tiwari. All rights reserved.
//

#import "USTLogger.h"
#import <unistd.h>


@implementation USTLogger

@synthesize stdErrRedirected;

static int savedStdErr = 0;
static USTLogger *sharedInstance;

+ (USTLogger *) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    return self;
}


- (void) writeNSLogToFile
{
    //[self restoreStdErr];
    
    if (!stdErrRedirected)
    {
        stdErrRedirected = YES;
        savedStdErr = dup(STDERR_FILENO);
        
        NSString *cachesDirectory =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
        NSString *logPath = [cachesDirectory stringByAppendingPathComponent:@"EventLog.log"];
        freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    }
}

- (void)restoreStdErr
{
    if (stdErrRedirected)
    {
        stdErrRedirected = NO;
        fflush(stderr);
        
        dup2(savedStdErr, STDERR_FILENO);
        close(savedStdErr);
        savedStdErr = 0;
    }
}

@end
