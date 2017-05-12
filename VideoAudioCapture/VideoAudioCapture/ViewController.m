//
//  ViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/10.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "ViewController.h"
#import "MCaptureViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *functionList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"流媒体";
    self.functionList = [NSMutableArray arrayWithObjects:@"视频采集",@"直播视频", nil];
    [self setupTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_functionList.count > 0) {
        return _functionList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"cellIdn";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.functionList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"视频采集"]) {
        MCaptureViewController *captureVC = [MCaptureViewController new];
        [self.navigationController pushViewController:captureVC animated:YES];
    }else{
        NSLog(@"直播视频");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
