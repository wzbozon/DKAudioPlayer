//
//  AppDelegate.m
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 17.01.14.

#import "AppDelegate.h"
#import "ViewController.h"
#import "DKAudioPlayerExample-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.tabBarController addChildViewController:viewController];
    
    AudioTableViewController *tableViewController = [[AudioTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    [self.tabBarController addChildViewController:navigationController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupAppearance {
    UITabBarAppearance *tabBarAppearance = [UITabBarAppearance new];
    [tabBarAppearance configureWithOpaqueBackground];
    tabBarAppearance.backgroundColor = [UIColor whiteColor];
    UITabBar.appearance.standardAppearance = tabBarAppearance;

    if (@available(iOS 15, *)) {
        UITabBar.appearance.scrollEdgeAppearance = tabBarAppearance;
    }
}

@end
