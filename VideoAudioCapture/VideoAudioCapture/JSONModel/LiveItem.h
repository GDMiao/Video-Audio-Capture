//
//  LiveItem.h
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AnchorItem;

@interface LiveItem : NSObject
/**
 主播
 */
@property (strong, nonatomic) AnchorItem *creator;
/**
 id
 */
@property (assign, nonatomic) NSInteger id__;

/**
 name
 */
@property (strong, nonatomic) NSString *name;

/**
 city
 */
@property (strong, nonatomic) NSString *city;

/**
 share_addr
 */
@property (strong, nonatomic) NSString *share_addr;

/**
 stream_addr
 */
@property (strong, nonatomic) NSString *stream_addr;

/**
 online_users
 */
@property (strong, nonatomic) NSString *online_users;
@end
