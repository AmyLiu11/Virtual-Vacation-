//
//  CalculatorAppDelegate.m
//  TopPlaces
//
//  Created by apple apple on 12-2-23.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  // UIImage *tabbarView = [UIImage imageNamed:@"tabbar.png"];
 //   UIImage * indicatorImage = [UIImage imageNamed:@"selection-tab2.png"];
   // [[UITabBar appearance] setBackgroundImage:tabbarView];
  //   [[UITabBar appearance] setSelectionIndicatorImage:indicatorImage];
    [[UINavigationBar appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
        [UIFont systemFontOfSize:22], UITextAttributeFont,
        [UIColor blackColor],UITextAttributeTextColor,nil
        ]];
   // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
  //  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"woodnavbarbackground"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance]    setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor] forState:UIControlStateSelected];
    //[[UIBarButtonItem appearance] setBackgroundImage:indicatorImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[[UITabBarItem appearance] setBackgroundImage: [UIImage imageNamed:@"selection-tab"]];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
