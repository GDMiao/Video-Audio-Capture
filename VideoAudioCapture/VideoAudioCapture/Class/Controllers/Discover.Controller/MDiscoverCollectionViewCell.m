//
//  MDiscoverCollectionViewCell.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MDiscoverCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "LiveItem.h"
#import "AnchorItem.h"
@implementation MDiscoverCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLivesData:(LiveItem *)live
{
    _live = live;
    self.nick.text = live.creator.nick;
    
    NSURL *imageUrl = [NSURL URLWithString:live.creator.portrait];
    [self.portraitImgView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    [self.portraitImgView sd_setImageWithURL:imageUrl placeholderImage:nil];
    self.city.text = live.city;
    
}
@end
