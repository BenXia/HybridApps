//
//  CookieMonster.m
//  SharedCookies
//
//  Created by Mike Keller on 8/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "CookieMonster.h"
#import "Hostname.h"

//Notifications
NSString *const CookieMonsterDidGetCookieNotification = @"CookieMonsterDidGetCookieNotification";

//Constants
static NSString *const kCookieMonsterCodeKey = @"code";
static NSString *const kCookieMonsterHtml = @"monster.html";

@interface CookieMonster()
@property (copy, nonatomic) CookieMonsterCompletion completion;
@property (strong, nonatomic) SFSafariViewController *safari;
@end

@implementation CookieMonster

- (void) fetchStoredCookiesWithViewController:(UIViewController*)viewController
                                   completion:(CookieMonsterCompletion)completion {

  if (self.safari) self.safari = nil;
  
  self.completion = completion;
  
  NSString *host = [Hostname hostname];
  NSString *urlString = [NSString stringWithFormat:@"%@/%@", host, kCookieMonsterHtml];
  NSURL *url = [NSURL URLWithString:urlString];
  
  [self observeCookieNotification];
  
  self.safari = [[SFSafariViewController alloc] initWithURL:url];
  self.safari.delegate = self;
  self.safari.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  self.safari.view.userInteractionEnabled = NO;
  self.safari.view.layer.opacity = 0.0F;
  self.safari.view.frame = CGRectZero;
  [viewController presentViewController:self.safari
                               animated:NO
                             completion:^{
                             }];
  
}

+ (BOOL) handleOpenUrl:(NSURL*)url {
  
  NSString *code = [self codeFromUrl:url];
  NSDictionary *userInfo = code ? @{kCookieMonsterCodeKey : code} : nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:CookieMonsterDidGetCookieNotification
                                                      object:url
                                                    userInfo:userInfo];
  return YES;
}

#pragma mark - SFSafariViewController

- (void) safariViewController:(SFSafariViewController *)controller
       didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
  
  //Could not load page, remove safari view controller
  if (!didLoadSuccessfully) {
    [self dismissSafariWithCode:nil];
  }
}

#pragma mark - Private

- (void) dismissSafariWithCode:(NSString*)code {
  
  __weak typeof(self) weakSelf = self;
  [self.safari dismissViewControllerAnimated:NO
                                  completion:^{
                                    if (weakSelf.completion) {
                                      weakSelf.completion(code);
                                    }
                                  }];
}

+ (NSString*) codeFromUrl:(NSURL*)url {
  NSURLComponents *components = [NSURLComponents componentsWithURL:url
                                           resolvingAgainstBaseURL:NO];
  NSArray <NSURLQueryItem*>*queryItems = components.queryItems;
  
  for (NSURLQueryItem *queryItem in queryItems) {
    if ([queryItem.name isEqualToString:kCookieMonsterCodeKey]) {
      return queryItem.value;
    }
  }
  
  return nil;
}

+ (NSString*) codeFromNotification:(NSNotification*)notification {
  if ([notification.name isEqualToString:CookieMonsterDidGetCookieNotification] == NO) return nil;
  NSDictionary *userInfo = notification.userInfo;
  if (!userInfo) return nil;
  
  id code = userInfo[kCookieMonsterCodeKey];
  if (!code || [code isKindOfClass:[NSString class]] == NO) return nil;
  
  return code;
}

- (void) observeCookieNotification {
  __weak NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
  __weak typeof(self) weakSelf = self;
  __block __weak id<NSObject> observer = [noteCenter addObserverForName:CookieMonsterDidGetCookieNotification
                                                                 object:nil
                                                                  queue:nil
                                                             usingBlock:^(NSNotification * _Nonnull note) {
                                                               NSString *code = [CookieMonster codeFromNotification:note];
                                                               [weakSelf dismissSafariWithCode:code];
                                                               [noteCenter removeObserver:observer];
                                                              }];
}


@end
