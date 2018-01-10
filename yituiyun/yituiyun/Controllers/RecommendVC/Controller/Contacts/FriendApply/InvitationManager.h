/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


//  用来处理UIDemo上的数据，您使用时请自己处理相关部分db

#import <Foundation/Foundation.h>

@class ApplyEntity;
@interface InvitationManager : NSObject

+ (instancetype)sharedInstance;

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username;

@end

@interface ApplyEntity : NSObject 

@property (nonatomic, copy) NSString * applicantUsername;
@property (nonatomic, copy) NSString * applicantNick;
@property (nonatomic, copy) NSString * applicantHeader;
@property (nonatomic, copy) NSString * reason;
@property (nonatomic, copy) NSString * receiverUsername;
@property (nonatomic, copy) NSString * receiverNick;
@property (nonatomic, strong) NSNumber * style;
@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, copy) NSString * groupSubject;

@end
