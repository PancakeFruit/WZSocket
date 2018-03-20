//
//  AppDelegate.h
//  WZSocket
//
//  Created by 魏峥 on 2018/3/20.
//  Copyright © 2018年 魏峥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

