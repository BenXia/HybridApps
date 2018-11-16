//
//  LocalSubstitutionCacheViewController.m
//  LocalSubstitutionCache
//
//  Created by Matt Gallagher on 2010/09/06.
//  Copyright Matt Gallagher 2010. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "LocalSubstitutionCacheViewController.h"

@implementation LocalSubstitutionCacheViewController

- (void)viewDidLoad
{
	((UIWebView *)self.view).scalesPageToFit = YES;
	NSURLRequest *request =
		[NSURLRequest
			requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]];
	[(UIWebView *)self.view loadRequest:request];
}

- (void)dealloc
{
    [super dealloc];
}

@end
