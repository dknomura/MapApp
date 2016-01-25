//
//  WaitForNetworkToFinishDelegate.h
//  MapApp
//
//  Created by Aditya Narayan on 12/7/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WaitForNetworkToFinishDelegate <NSObject>
@required
-(void) onceNetworkComplete;
@end

@interface WaitForNetworkToFinishDelegate : NSObject

@property (strong, nonatomic) id <WaitForNetworkToFinishDelegate> delegate;
-(void) startToWaitForNetwork;
@end
