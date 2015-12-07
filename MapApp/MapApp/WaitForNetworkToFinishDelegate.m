//
//  WaitForNetworkToFinishDelegate.m
//  MapApp
//
//  Created by Aditya Narayan on 12/7/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import "WaitForNetworkToFinishDelegate.h"

@implementation WaitForNetworkToFinishDelegate

-(void) startToWaitForNetwork
{
    [NSTimer scheduledTimerWithTimeInterval:2 target:self.delegate selector:@selector(onceNetworkComplete) userInfo:nil repeats:NO];
}


@end
