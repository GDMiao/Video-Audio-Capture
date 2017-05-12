//
//  MDiscoverCollectionViewCell.h
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveItem;
@interface MDiscoverCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) LiveItem *live;
- (void)setLivesData:(LiveItem *)live;
@end
