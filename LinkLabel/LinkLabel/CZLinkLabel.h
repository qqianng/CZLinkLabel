//
//  CZLinkLabel.h
//  LinkLabel
//
//  Created by new on 17/3/7.
//  Copyright © 2017年 it.sozi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZLink;

typedef void(^CZLinkBlock)(CZLink *link);


@interface CZLinkLabel : UILabel

//点击链接后的回调。
@property (nonatomic,copy) CZLinkBlock linkBlock;

@end



@interface CZLink : NSObject
/**
 *  在富文本中的连接(话题 用户 http超连接)
 */
@property(nonatomic,copy)NSString *text;
/**
 *  连接位置
 */
@property(nonatomic,assign)NSRange range;

+ (instancetype)linkWithText:(NSString *)text range:(NSRange)range;

@end
