//
//  AppDelegate.m
//  NetworkConnection
//
//  Created by zivInfo on 17/2/8.
//  Copyright © 2017年 xiwangtech.com. All rights reserved.
//

#import "AppDelegate.h"

#import "Reachability.h"
#import "AFNetworkReachabilityManager.h"

@interface AppDelegate ()
{
    Reachability *hostReach;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 这种方法慢一点。
    [self reachability];
    
    // 这种方法快一点。
    [self reachabilityAFNetworking];

    // 根据状态栏获取，快。连接的WiFi没有联网的话，识别不到。
    [self getNetWorkStates];
    
    
    return YES;
}

#pragma mark -
#pragma mark - reachability
-(void)reachability
{
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    // 可以以多种形式初始化
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    // 开始监听,会启动一个run loop
    [hostReach startNotifier];
    [self updateInterfaceWithReachability:hostReach];
}

// 连接改变
- (void)reachabilityChanged: (NSNotification*)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}

// 处理连接改变后的情况
- (void)updateInterfaceWithReachability: (Reachability *)curReach
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    // 没有连接到网络就弹出提实况
    if (status == NotReachable) {
        NSLog(@"no1..");
    }
    else if (status == ReachableViaWiFi) {
        NSLog(@"wifi1..");
    }
    else if (status == ReachableViaWWAN) {
        NSLog(@"wlan1..");
    }
    else {
        NSLog(@"unknown1");
    }
}


#pragma mark -
#pragma mark - AFNetworking
- (void)reachabilityAFNetworking
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"unknown2");
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"no2");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"wlan2");
                
                break;
            default:
                NSLog(@"wifi2");
                break;
        }
    }];
    
    [mgr startMonitoring];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self reachability];
}


#pragma mark -
#pragma mark - 根据状态栏获取（连接的WiFi没有联网的话，识别不到。）
- (void) getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    int netType = 0;
    
    // 获取到网络返回码
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            // 获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    NSLog(@"no3..");
                    //无网模式
                    break;
                case 1:
                    NSLog(@"2G3..");
                    break;
                case 2:
                    NSLog(@"3G3..");
                    break;
                case 3:
                    NSLog(@"4G3..");
                    break;
                case 5:
                    NSLog(@"WiFi3..");
                    break;
                default:
                    break;
            }
        }
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
