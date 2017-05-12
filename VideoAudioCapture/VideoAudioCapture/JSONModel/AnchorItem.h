//
//  AnchorItem.h
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnchorItem : NSObject

/**
 nick 主播名字
 */
@property (strong, nonatomic) NSString *nick;
/**
 portrait 头像
 */
@property (strong, nonatomic) NSString *portrait;

/**
 level 等级
 */
@property (assign, nonatomic) int level;

/**
 gender 性别
 */
@property (assign, nonatomic) int gender;

/**
 id ID
 */
@property (assign, nonatomic) NSInteger id_;
@end
