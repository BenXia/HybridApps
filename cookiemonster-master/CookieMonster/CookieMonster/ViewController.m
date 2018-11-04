//
//  ViewController.m
//  CookieMonster
//
//  Created by Mike Keller on 8/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "CookieMonster.h"
#import "Hostname.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) CookieMonster *cookieMonster;
@property (weak, nonatomic) IBOutlet UIButton *cookieButton;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.cookieMonster = [[CookieMonster alloc] init];
  
  self.cookieButton.layer.cornerRadius = 3.0F;
}

#pragma mark - Actions

- (IBAction) tappedActionButton:(id)sender {
  
  __weak typeof(self) weakSelf = self;
  [self.cookieMonster fetchStoredCookiesWithViewController:self
                                                completion:^(NSString *code) {
                                                  [weakSelf showSuccessWithCode:code];
                                                }];
}

- (IBAction) tappedCreateCodeButton:(id)sender {
  [self showCreateCode];
}

#pragma mark - Private

- (void) showCreateCode {
  
  NSString *host = [Hostname hostname];
  NSString *createCodeUrlString = [NSString stringWithFormat:@"%@/index.html", host];
  NSURL *url = [NSURL URLWithString:createCodeUrlString];
  [[UIApplication sharedApplication] openURL:url];
}

- (void) showSuccessWithCode:(NSString*)code {
  NSString *title = code ? @"Ate a cookie" : @"Error";
  NSString *message = code ? [NSString stringWithFormat:@"Code: %@", code] : @"Could not fetch cookie.";
  NSString *buttonTitle = code ? @"Nom Nom" : @"OK";
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
  [alert addAction:okAction];
  
  [self presentViewController:alert
                     animated:YES
                   completion:^{}];
}

@end
