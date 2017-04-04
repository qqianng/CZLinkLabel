# [CZLinkLabel](https://github.com/qqianng/CZLinkLabel/edit/master/)
一个自定义的Label，可以识别文本中的链接，话题，协议等等。

## Requirements
支持iOS8.0。

## Adding CZLinkLabel to your project
1. 将“CZLinkLabel.h”和“CZLinkLabel.m”添加到项目中。
2. #import "CZLinkLabel.h"

## Usage
你可以通过label.text来设置文本，并通过label1.linkBlock来监听用户的点击事件。如果label中有多个链接，你可以通过link.text来判断用户具体点击了哪一个链接。
```
    //use label`s text property.
    CZLinkLabel *label1 = [[CZLinkLabel alloc] initWithFrame:CGRectMake(100, 100, 300, 30)];
    label1.text = @"我已阅读并同意《用户协议》";
    label1.linkBlock = ^ (CZLink *link) {
        NSLog(@"user did click the link, the text of link is %@", link.text);
        //custom operation。。。
    };
    [self.view addSubview:label1];
``` 

你也可以通过label.attributedText来设置文本。
```
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
```    
  
如果你使用的是xib，你需要将label的class修改为CZLinkLabel,并通过代码设置linkBlock。



