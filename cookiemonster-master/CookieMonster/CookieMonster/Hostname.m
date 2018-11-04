//
//  Hostname.m
//  CookieMonster
//
//  Created by Mike Keller on 8/10/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "Hostname.h"

@implementation Hostname

+ (NSString*) hostname {
  NSString *hostFilePath = [[NSBundle mainBundle] pathForResource:@"host" ofType:@"txt"];
  NSError *error = nil;
  NSString *hostUrl = [NSString stringWithContentsOfFile:hostFilePath
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
  NSString *httpPort = @"8000";
  NSString *apiBaseUrl = [NSString stringWithFormat:@"http://%@:%@", hostUrl, httpPort];
  if (error || !apiBaseUrl) {
    NSLog(@"Could not find host file.");
  }
  return apiBaseUrl;
}

@end
