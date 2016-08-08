//
//  AppDelegate.m
//  ;
//
//  Created by 洪鹏宇 on 16/2/1.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [UIWindow new];
    LaunchViewController *launchVC = [UIStoryboard storyboardWithName:@"LaunchStoryboard" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    self.window.rootViewController = launchVC;
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self mainViewController];
    });
    
    return YES;
}

- (MainViewController *)mainViewController {
    if (!_mainViewController) {
        HomeViewController *homeVC = [HomeViewController new];
        LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        leftMenuVC.view.frame = kScreenBounds;
        _mainViewController = [[MainViewController alloc]initWithLeftMenuViewController:leftMenuVC andHomeViewController:homeVC];
    }
    return _mainViewController;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TapStatusBar" object:nil];
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
