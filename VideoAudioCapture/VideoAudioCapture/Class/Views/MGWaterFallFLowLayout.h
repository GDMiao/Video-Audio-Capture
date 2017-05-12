//
//  MGWaterFallFLowLayout.h
//  MGWaterFall
//
//  Created by 苗国栋 on 2017/3/24.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGWaterFallFLowLayout;

@protocol MGWaterFallFlowLayoutDelegate <NSObject>

@required
- (CGFloat)MGWaterFallFlowLayoutHeightForItem; // 返回一个item的高度
@optional
- (NSInteger)MGWaterFallFlowLayoutColumnCount;  // 瀑布流列数 // 默认3列
- (CGFloat)MGWaterFallFlowLayoutCulumnSpacing;  // 瀑布流列间距
- (CGFloat)MGWaterFallFlowLayoutLineSpacing;    // 瀑布流行间距
- (UIEdgeInsets)MGWaterFallFlowLayoutEdgInsets; // 瀑布流边距

@end

@interface MGWaterFallFLowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MGWaterFallFlowLayoutDelegate>delegate;
@end
