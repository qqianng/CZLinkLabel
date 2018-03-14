//
//  CZLinkLabel.m
//  LinkLabel
//
//  Created by new on 17/3/7.
//  Copyright © 2017年 it.sozi. All rights reserved.
//

//链接未点击时的颜色。
#define CZLinkNormalColor [UIColor blueColor]
//链接长按时的颜色。
#define CZLinkHighlightedColor [UIColor grayColor]
#import "CZLinkLabel.h"

@interface CZLinkLabel ()

@property(nonatomic,strong)NSMutableArray *links;//CZLink数组
@property(nonatomic,strong)CZLink  *selectedLink;//当前选中的link
@property (nonatomic,strong) NSMutableAttributedString *attrTextM;//可变的属性文本，用于添加文本属性。

@end


@implementation CZLinkLabel


- (void)awakeFromNib {
    [super awakeFromNib];
    self.attrTextM = [[NSMutableAttributedString alloc] initWithString:self.text];
    [self setupUI];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.attrTextM = [[NSMutableAttributedString alloc] initWithString:self.text];
    [self setupUI];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    //只在外界给attributedText属性赋值的情况下，才设置UI。内部通过self.attrTextM设置，直接返回，防止死循环。
    if (attributedText == self.attrTextM) {
        return;
    }
    self.attrTextM = [attributedText mutableCopy];
    [self setupUI];
}

- (void)setupUI {
    //创建新的数组，防止上一次结果的干扰。
    self.links = [NSMutableArray array];
    self.userInteractionEnabled = YES;
    //设置文本的字体。这样系统才能正确计算textContainer的bounds。
    [self.attrTextM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.attrTextM.length)];
    
    NSArray *patterns = @[@"[a-zA-Z]*://[a-zA-Z0-9/\\.]*", @"#.*?#", @"@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*", @"《.*?》", @"<.*?>"];
    for (NSString *pattern in patterns) {
        //匹配正则表达式
        [self matchPattern:pattern];
    }
    
    self.attributedText = self.attrTextM;
}


#pragma mark - Touch event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeLinksBackground];
    //1.获取点击位置
    UITouch *touch  = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    //2.获取点击位置的链接
    self.selectedLink = [self getClickLinkWithPoint:point];
    
    //3.添加链接背景
    if (self.selectedLink) {
        [self.attrTextM addAttribute:NSBackgroundColorAttributeName value:CZLinkHighlightedColor range:self.selectedLink.range];
        self.attributedText = self.attrTextM;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //移除链接背景
    [self removeLinksBackground];
}

//根据手指最后停留的位置，处理对应的事件。
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //移除链接背景
    [self removeLinksBackground];
    
    UITouch *touch  = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    CZLink *clickLink = [self getClickLinkWithPoint:point];
    //处理事件
    if (clickLink) {
//        NSLog(@"%@",clickLink.text);
        
        if (self.linkBlock) {
            self.linkBlock(self.selectedLink);
        }
    }
}


#pragma mark - Self

//匹配格式
- (void)matchPattern:(NSString *)pattern {
    NSString *text = self.attrTextM.string;
    NSError *error = nil;
    //创建正则表达式对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"创建正则表达式失败%@",error);
        return;
    }
    
    //匹配结果
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches) {
        CZLink *link = [[CZLink alloc] init];
        link.text = [text substringWithRange:match.range];
        link.range = match.range;
        [self.links addObject:link];
        [self.attrTextM addAttribute:NSForegroundColorAttributeName value:CZLinkNormalColor range:link.range];
    }
}

//移除链接背景
-(void)removeLinksBackground {
    if (self.selectedLink) {
        [self.attrTextM removeAttribute:NSBackgroundColorAttributeName range:self.selectedLink.range];
        self.attributedText = self.attrTextM;
    }
}

//获取点击位置对应的连接
-(CZLink *)getClickLinkWithPoint:(CGPoint)point{
    
    CGSize labelSize = self.bounds.size;
    // create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    // configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // configure textContainer for the label
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.size = labelSize;
    
    //find the tapped character location and compare it to the specified range
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGFloat factorX;
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:
            factorX = 0;
            break;
        case NSTextAlignmentCenter:
            factorX = 0.5;
            break;
        case NSTextAlignmentRight:
            factorX = 1.0;
            break;
        default:
            factorX = 0.5;
            break;
    }
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * factorX, (labelSize.height - textBoundingBox.size.height) * 0.5);
    CGPoint locationOfTouchInTextContainer = CGPointMake(point.x - textContainerOffset.x,
                                                         point.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                       inTextContainer:textContainer
                              fractionOfDistanceBetweenInsertionPoints:nil];
//    NSLog(@"indexOfCharacter -- %ld",indexOfCharacter);
    
    CZLink *clickLink = nil;
    // 查找连接
    for (CZLink *link in self.links) {
        if (NSLocationInRange(indexOfCharacter, link.range)) {
            clickLink = link;
            break;
        }
    }
    return clickLink;
}


@end




@implementation CZLink

+ (instancetype)linkWithText:(NSString *)text range:(NSRange)range {
    CZLink *link = [[CZLink alloc] init];
    link.text = text;
    link.range = range;
    return link;
}


@end
