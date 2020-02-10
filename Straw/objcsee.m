//
//  objcsee.m
//  Straw
//
//  Created by Max Goedjen on 2/10/20.
//  Copyright © 2020 Max Goedjen. All rights reserved.
//

#import "objcsee.h"
#import "SimServiceContext.h"
#import "SimDeviceSet.h"
#import "SimDevice.h"
#import "SimRuntime.h"

@implementation objcsee

+ (void)test {
    SimServiceContext *ctx = [SimServiceContext sharedServiceContextForDeveloperDir:@"/Applications/Xcode.app/Contents/Developer" error:nil];
    SimDeviceSet *set = [ctx defaultDeviceSetWithError:nil];
    SimDevice *device = set.devices.firstObject;
    [device registerNotificationHandlerOnQueue:dispatch_get_main_queue() handler:^{
        NSLog(@"OK");
    }];
    NSLog(@"ctx %@", device);
}

@end
