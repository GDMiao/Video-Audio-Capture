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
  
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
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
