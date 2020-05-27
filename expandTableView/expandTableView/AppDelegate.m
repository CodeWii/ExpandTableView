//
//  AppDelegate.m
//  expandTableView
//
//  Created by 王同学 on 2020/5/27.
//  Copyright © 2020 Simple. All rights reserved.
//

#import "AppDelegate.h"
#import "ExpandTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ExpandTableViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
