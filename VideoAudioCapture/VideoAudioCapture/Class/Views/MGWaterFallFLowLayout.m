//
//  MGWaterFallFLowLayout.m
//  MGWaterFall
//
//  Created by 苗国栋 on 2017/3/24.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MGWaterFallFLowLayout.h"
#define sectionNumber 0

// 默认瀑布流 值
static NSInteger const DefaultColumnCount = 3;
static CGFloat const DefaultColumnSpacing = 10;
static CGFloat const DefaultLineSpacing = 10;
static UIEdgeInsets const DefaultEdgeInsets = {10,10,10,10};

@interface MGWaterFallFLowLayout ()
@property (nonatomic, strong) NSMutableArray * attrArray;
@property (nonatomic, strong) NSMutableArray * maxArray;

- (CGFloat)cellHeight;
- (NSInteger)columneCount;
- (CGFloat)columnSpacing;
- (CGFloat)lineSpacing;
- (UIEdgeInsets)edgeInsets;

@end

@implementation MGWaterFallFLowLayout
/**
 * layout 代理返回值
 *
 *
 **/
- (CGFloat)cellHeight
{
    if ([self.delegate respondsToSelector:@selector(MGWaterFallFlowLayoutHeightForItem)]) {
        return [self.delegate MGWaterFallFlowLayoutHeightForItem];
    }
    return 100 + arc4random_uniform(100); // 代理无值默认值
}
- (NSInteger)columneCount
{
    if ([self.delegate respondsToSelector:@selector(MGWaterFallFlowLayoutColumnCount)]) {
        return [self.delegate MGWaterFallFlowLayoutColumnCount];
    }
    return DefaultColumnCount;
}

- (CGFloat)columnSpacing
{
    if ([self.delegate respondsToSelector:@selector(MGWaterFallFlowLayoutCulumnSpacing)]) {
        return [self.delegate MGWaterFallFlowLayoutCulumnSpacing];
    }
    return DefaultColumnSpacing;
}

- (CGFloat)lineSpacing
{
    if ([self.delegate respondsToSelector:@selector(MGWaterFallFlowLayoutLineSpacing)]) {
        return [self.delegate MGWaterFallFlowLayoutLineSpacing];
    }
    return DefaultLineSpacing;
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(MGWaterFallFlowLayoutEdgInsets)]) {
        return [self.delegate MGWaterFallFlowLayoutEdgInsets];
    }
    return DefaultEdgeInsets;
}

/**
 * 重写 数组的 getter 方法
 *
 **/
- (NSMutableArray *)attrArray
{
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableArray *)maxArray
{
    if (!_maxArray) {
        _maxArray = [NSMutableArray array];
    }
    return _maxArray;
}

/**
 *
 * 自定义Layout必须实现的四个方法
 *
 **/

- (void)prepareLayout
{
    [super prepareLayout];
    [self.attrArray removeAllObjects];
    [self.maxArray removeAllObjects];
    
    for (NSInteger i = 0; i < [self columneCount]; i++) {
        [self.maxArray addObject:@([self edgeInsets].top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.attrArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    return self.attrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger __block minHeightColumn = 0; // 最短列号
    NSInteger __block minHeight = [self.maxArray[minHeightColumn] floatValue];
    
    [self.maxArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        if (minHeight > columnHeight ) {
            minHeight = columnHeight;
            minHeightColumn = idx;
        }
    }];

    UIEdgeInsets edgeInsets_MG = [self edgeInsets];
    NSInteger columnCount_MG = [self columneCount];
    CGFloat columnSpacing_MG = [self columnSpacing];
    
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - edgeInsets_MG.left - edgeInsets_MG.right - columnSpacing_MG * (columnCount_MG - 1)) / columnCount_MG;
    
    CGFloat itemHight = [self cellHeight];
    
    CGFloat itemOriginX = edgeInsets_MG.left + minHeightColumn * (itemWidth + columnSpacing_MG);
    
    CGFloat itemOriginY = minHeight;
    if (itemOriginY != edgeInsets_MG.top) {
        itemOriginY += columnSpacing_MG;
    }
    
    [attributes setFrame:CGRectMake(itemOriginX, itemOriginY, itemWidth, itemHight)];
    self.maxArray[minHeightColumn] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    
    NSInteger __block maxHeight = 0;
    
    [self.maxArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        if (maxHeight < columnHeight ) {
            maxHeight = columnHeight;
            
        }
    }];
    
    return CGSizeMake(0, maxHeight + [self columnSpacing]);
}

@end
