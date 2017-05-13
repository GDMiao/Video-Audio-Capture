//
//  AFN-Network.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/12.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "AFN-Network.h"
#import <AFNetworking/AFNetworking.h>

static AFN_Network *afn_net = nil;



@interface AFN_Network ()

@end

@implementation AFN_Network

static AFHTTPSessionManager *manager;

+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置15秒超时 - 取消请求
        manager.requestSerializer.timeoutInterval = 15.0;
        // 编码
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 支持内容格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/JavaScript", @"text/json", @"text/html", nil];
    });
    
    return manager;
}

- (instancetype)AFN_Manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afn_net = [AFN_Network new];
    });
    return afn_net;
}

+ (void)afn_NetworkRequst:(AFN_Request_type)type URL:(NSString *)url AFN_NetworkDelegate:(id<AFN_NetworkDelegate>)delegate
{
    AFHTTPSessionManager *manager = [AFN_Network sharedHttpSessionManager];

    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSNumber *dm_error = [responseObject valueForKey:@"dm_error"];
        NSString *error_msg = [responseObject valueForKey:@"error_msg"];
        NSLog(@"1code:%@",dm_error);
        NSLog(@"1message:%@",error_msg);
        
        if (dm_error.intValue == 500) {
            
            [delegate AFN_RuqestFailed:error_msg];
            
        }else if (dm_error.intValue == 0){
            
            NSArray *content = [responseObject valueForKey:@"lives"];
            
            if (!content) {
                [delegate AFN_RuqestDataNull:error_msg];
            }else{
                [delegate AFN_RuqestSucceed:content Message:error_msg];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [delegate AFN_RuqestFailed:@"错误"];
    }];
    
}
@end
