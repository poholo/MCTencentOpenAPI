//
//  TencentReqMgr.h
//  sdkDemo
//
//  Created by xiaolongzhang on 13-6-1.
//  Copyright (c) 2013年 xiaolongzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TencentApiReq;
@class TencentApiResp;

//主要是用来管理请求的实例 方便第三方使用 注意杀进程可就没法使用了 暂时没有实现数据的本地保存
//这里返回的序列号和请求中的序列号是不相同的
@interface TencentReqMgr : NSObject

+ (TencentReqMgr *)instance;

/**
 * 添加一个实例
 * \param TencentApiReq实例
 * \return 序列号（这里的序列号和请求的序列号是不同的）
 */
- (NSInteger)addReq:(TencentApiReq *)req;

/**
 * 获得一个请求实例的序列号
 * \param TencentApiReq实例
 * \return 序列号（这里的序列号和请求的序列号是不同的）
 */
- (NSInteger)seqFromReq:(TencentApiReq *)req;

/**
 * 移除某一个实例
 * \param TencentApiReq实例
 */
- (void)rmReq:(TencentApiReq *)req;

/**
 * 移除某一个序列号对应的实例
 * \param 实例对应的序列号
 */
- (void)rmSeq:(NSInteger)seq;

/**
 * 获得一个请求对象的实例
 * \param seq 序列号
 */
- (TencentApiReq *)reqFromSeq:(NSInteger)seq;

/**
 * 获得一个答复实例
 * \param seq 序列号
 */
- (TencentApiResp *)respFromSeq:(NSInteger)seq;

/**
 * 获得一个请求实例中所有的TencentMessageObject对象实例
 * \param seq 序列号
 */
- (NSArray *)tencentMessageObjFromSeq:(NSInteger)seq;

/**
 * 获得一个请求实例中所有的指定的TencentMessageObject对象实例
 * \param seq 序列号
 * \param messageClass TencentMessageObject的Class类
 */
- (NSArray *)tencentMessageObjFromMessageClass:(NSInteger)seq messageClass:(Class)messageClass;

/**
 * 获得一个请求实例中所有的指定的TencentMessageObject对象实例
 * \param seq 序列号
 * \param messageType TencentMessageObject的消息类型
 */
- (NSArray *)tencentMessageObjFromMessageType:(NSInteger)seq messageType:(NSUInteger)messageType;

/**
 * 请求中是否包含指定的TencentMessageObject实例
 * \param seq 序列号
 * \param messageClass TencentMessageObject的Class类
 */
- (BOOL)isContainMessageClss:(NSInteger)seq messageClass:(Class)messageClass;

/**
 * 获得一个答复实例
 * \param seq 序列号
 * \param messageType TencentMessageObject的消息类型
 */
- (BOOL)isContainMessageType:(NSInteger)seq messageType:(NSUInteger)messageType;

@end
