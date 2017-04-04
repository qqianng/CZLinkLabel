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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CZLinkLabel *label = [[CZLinkLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    NSMutableAttributedString *attrTextM = [[NSMutableAttributedString alloc] initWithString:@"http://www.baidu.com/ @jane #广州天气# <abc vip>"];
    [attrTextM addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, attrTextM.length)];
    label.attributedText = attrTextM;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
