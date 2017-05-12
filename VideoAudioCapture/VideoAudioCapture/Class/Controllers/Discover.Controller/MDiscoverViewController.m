

//
//  MDiscoverViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MDiscoverViewController.h"
#import "MGWaterFallFLowLayout.h"
#import "MDiscoverCollectionViewCell.h"
#import "AFN-Network.h"
#import "LiveItem.h"
#import "AnchorItem.h"
#import "MJExtension.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
//http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1
@interface MDiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MGWaterFallFlowLayoutDelegate,AFN_NetworkDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *lives;
@end
static NSString  * const itemIdentifier = @"itemCell";
@implementation MDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self init_CollectionView];
    NSString *urlstring = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    [AFN_Network afn_NetworkRequst:AFN_Get URL:urlstring AFN_NetworkDelegate:self];
}

- (void)init_CollectionView
{
    MGWaterFallFLowLayout *layout = [[MGWaterFallFLowLayout alloc]init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) collectionViewLayout:layout];
    [self.collectionView registerClass:[MDiscoverCollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.view addSubview:self.collectionView];
    
}

- (void)AFN_RuqestSucceed:(NSArray *)json Message:(NSString *)message
{
    //NSLog(@"1.%@",message);
    //NSLog(@"jsonObject:%@",json);
    
    _lives = [LiveItem mj_objectArrayWithKeyValuesArray:json];
  
    [self.collectionView reloadData];
}

- (void)AFN_RuqestFailed:(NSString *)message
{
    NSLog(@"2.%@",message);
}
- (void)AFN_RuqestDataNull:(NSString *)message
{
    NSLog(@"3.%@",message);
}

#pragma mark - collectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.lives) {
        return self.lives.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //在这里注册自定义的XIBcell否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"MDiscoverCollectionViewCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:itemIdentifier];
    MDiscoverCollectionViewCell *itemcell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];

    itemcell.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
    [itemcell setLivesData:self.lives[indexPath.row]];
    return itemcell;
}

#pragma mark -MGWaterFallFlowLayoutDelegate
- (CGFloat)MGWaterFallFlowLayoutHeightForItem
{
//    return 150 + arc4random_uniform(100); // 给一个随机值  可根据数据自行更改
    return 230;
}
// 可选方法
- (NSInteger)MGWaterFallFlowLayoutColumnCount
{
    return 2; // 返回一个 瀑布流 列数
}

- (CGFloat)MGWaterFallFlowLayoutCulumnSpacing
{
    return 10; // 返回一个 瀑布流 行间距
}

- (UIEdgeInsets)MGWaterFallFlowLayoutEdgInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    return edgeInsets; // 返回一个 瀑布流 边距
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
