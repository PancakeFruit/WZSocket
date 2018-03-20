//
//  WZSocketManager.h
//  Camera
//
//  Created by 魏峥 on 17/6/14.
//  Copyright © 2017年 魏峥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZSocketManager : NSObject

+ (instancetype)share;

- (BOOL)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;

@end
