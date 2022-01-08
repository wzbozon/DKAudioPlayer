//
//  AppDelegate.m
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 17.01.14.

#import "AppDelegate.h"
#import "ViewController.h"
#import "TableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tabBarController = [[UITabBarController alloc] init];
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.tabBarController addChildViewController:viewController];
    
    TableViewController *tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    [self.tabBarController addChildViewController:navigationController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
