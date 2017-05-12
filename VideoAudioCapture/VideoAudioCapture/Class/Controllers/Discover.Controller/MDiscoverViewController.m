//
//  MDiscoverViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MDiscoverViewController.h"
#import "MGWaterFallFLowLayout.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MDiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MGWaterFallFlowLayoutDelegate>

@property (strong, nonatomic)  UICollectionView *collectionView;
@end
static NSString  * const itemIdentifier = @"itemCell";
@implementation MDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self init_CollectionView];
}

- (void)init_CollectionView
{
    MGWaterFallFLowLayout *layout = [[MGWaterFallFLowLayout alloc]init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - collectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *itemcell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    itemcell.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
    
    
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
