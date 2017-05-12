//
//  AFN-Network.h
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFN_Network;
@protocol AFN_NetworkDelegate <NSObject>

@optional
- (void)AFN_RuqestSucceed:(NSArray *)json Message:(NSString *)message;
- (void)AFN_RuqestDataNull:(NSString *)message;
- (void)AFN_RuqestFailed:(NSString *)message;

@end
@interface AFN_Network : NSObject
typedef NS_ENUM(NSUInteger, AFN_Request_type) {
    AFN_Get,
    AFN_Post,
};
@property (weak, nonatomic) id<AFN_NetworkDelegate>afnDelegate;

- (instancetype)AFN_Manager;

+ (void)afn_NetworkRequst:(AFN_Request_type)type URL:(NSString *)url AFN_NetworkDelegate:(id<AFN_NetworkDelegate>)delegate;

@end
