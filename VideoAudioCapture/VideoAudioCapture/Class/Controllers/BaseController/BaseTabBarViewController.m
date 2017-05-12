//
//  BaseTabBarViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationViewController.h"
#import "MDiscoverViewController.h"
#import "MCaptureViewController.h"
@interface BaseTabBarViewController ()
{
    MDiscoverViewController *discoverVC;
    MCaptureViewController *captureVC;
}
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarElement];
}

- (void)setupTabBarElement
{
    self.tabBar.tintColor = [UIColor yellowColor];
    discoverVC = [MDiscoverViewController new];
    UIImage *disImg = [UIImage imageNamed:@"发现1-0"];
    UIImage *disSelImg = [UIImage imageNamed:@"发现1-1"];
    discoverVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:disImg selectedImage:disSelImg];
    
    
    
    BaseNavigationViewController *discoverNav = [[BaseNavigationViewController alloc]initWithRootViewController:discoverVC];
    
    captureVC = [MCaptureViewController new];
    UIImage *capImg = [UIImage imageNamed:@"视频1-0"];
    UIImage *capSelImg = [UIImage imageNamed:@"视频1-1"];
    captureVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"视频" image:capImg selectedImage:capSelImg];
    
    BaseNavigationViewController *captureNav = [[BaseNavigationViewController alloc]initWithRootViewController:captureVC];
    [self addChildViewController:discoverNav];
    [self addChildViewController:captureNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
