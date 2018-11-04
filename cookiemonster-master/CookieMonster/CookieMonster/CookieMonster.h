//
//  CookieMonster.h
//  SharedCookies
//
//  Created by Mike Keller on 8/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import SafariServices;
@import UIKit;

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const CookieMonsterDidGetCookieNotification;

typedef void(^CookieMonsterCompletion)(NSString *code);

@interface CookieMonster : NSObject <SFSafariViewControllerDelegate>

- (void) fetchStoredCookiesWithViewController:(UIViewController*)viewController
                                   completion:(CookieMonsterCompletion)completion;

+ (BOOL) handleOpenUrl:(NSURL*)url;

@end
