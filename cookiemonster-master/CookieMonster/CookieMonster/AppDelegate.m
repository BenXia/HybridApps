//
//  AppDelegate.m
//  CookieMonster
//
//  Created by Mike Keller on 8/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "CookieMonster.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  return YES;
}

- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<NSString *,id> *)options {
  return [CookieMonster handleOpenUrl:url];
}

@end
