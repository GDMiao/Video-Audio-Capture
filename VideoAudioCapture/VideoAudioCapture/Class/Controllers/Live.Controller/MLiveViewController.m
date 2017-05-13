//
//  MLiveViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/13.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MLiveViewController.h"
#import <UIImageView+WebCache.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LiveItem.h"
#import "AnchorItem.h"
@interface MLiveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *placeImgView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIButton *backBt;
@end

@implementation MLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置直播占位图片
    NSURL *imageUrl = [NSURL URLWithString:_live.creator.portrait];
    [self.placeImgView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    // 拉流地址
    NSURL *url = [NSURL URLWithString:_live.stream_addr];
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    // 准备播放
    [playerVc prepareToPlay];
    
    // 强引用，反正被销毁
    _player = playerVc;
    
    playerVc.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:playerVc.view atIndex:1];

}
- (IBAction)backBtAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
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
