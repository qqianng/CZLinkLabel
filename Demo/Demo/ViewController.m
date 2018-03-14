//
//  ViewController.m
//  LinkLabel
//
//  Created by new on 17/3/7.
//  Copyright © 2017年 it.sozi. All rights reserved.
//

#import "ViewController.h"
#import "CZLinkLabel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CZLinkLabel *xibLinkLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //use label`s text property.
    CZLinkLabel *label1 = [[CZLinkLabel alloc] initWithFrame:CGRectMake(100, 100, 300, 30)];
    label1.text = @"我已阅读并同意《用户协议》";
    label1.linkBlock = ^ (CZLink *link) {
        NSLog(@"user did click the link, the text of link is %@", link.text);
        //custom operation。。。
    };
    [self.view addSubview:label1];
    
    
    // use label`s attributedText property
    CZLinkLabel *label2 = [[CZLinkLabel alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    label2.linkBlock = ^ (CZLink *link) {
        NSLog(@"user did click the link, the text of link is %@", link.text);
        //custom operation。。。
    };
    NSMutableAttributedString *attrTextM = [[NSMutableAttributedString alloc] initWithString:@"这是链接http://www.baidu.com/    这是呼叫@jane   这是话题#广州天气#  这是协议<some protocol>"];
    [attrTextM addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, attrTextM.length)];
    label2.attributedText = attrTextM;
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    
    //use xib
    self.xibLinkLabel.linkBlock = ^ (CZLink *link) {
        NSLog(@"user did click the link, the text of link is %@", link.text);
        //custom operation。。。
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
