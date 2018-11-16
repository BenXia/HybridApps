//
//  LocalSubstitutionCacheAppDelegate.m
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

#import "LocalSubstitutionCacheAppDelegate.h"
#import "LocalSubstitutionCacheViewController.h"
#import "LocalSubstitutionCache.h"

@implementation LocalSubstitutionCacheAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Set the URL cache and leave it set permanently
	LocalSubstitutionCache *cache = [[LocalSubstitutionCache alloc] init];
	[NSURLCache setSharedURLCache:cache];

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
