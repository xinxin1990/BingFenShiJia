//
//  BFFunctionButtonView.m
//  缤微纷购
//
//  Created by 程召华 on 16/3/5.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import "BFFunctionButtonView.h"
#import "BFFuctionButton.h"

@interface BFFunctionButtonView()
@property (nonatomic, strong) UIView *bgView;

@end

@implementation BFFunctionButtonView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setView];
    }
    return self;
}
- (void)setView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    //self.bgView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.bgView];
    
    UIView *verticalLineLeft = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3-0.5, 0, 1, self.height)];
    verticalLineLeft.backgroundColor = BFColor(0xDDDFDA);
    [self addSubview:verticalLineLeft];
    
    UIView *verticalLineRight = [[UIView alloc] initWithFrame:CGRectMake(2*ScreenWidth/3-0.5, 0, 1, self.height)];
    verticalLineRight.backgroundColor = BFColor(0xDDDFDA);
    [self addSubview:verticalLineRight];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2-0.5, ScreenWidth, 1)];
    horizontalLine.backgroundColor = BFColor(0xDDDFDA);
    [self addSubview:horizontalLine];
    

    BFFuctionButton *myWallet = [self setUpButtonWithframe:CGRectMake(0, 0, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyWallet image:@"my_wallet" titleText:@"我的钱包"];
    [self.bgView addSubview:myWallet];
    
    BFFuctionButton *myOrder = [self setUpButtonWithframe:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyOrder image:@"my_order" titleText:@"我的订单"];
    [self.bgView addSubview:myOrder];
    
    BFFuctionButton *myGroupPurchase = [self setUpButtonWithframe:CGRectMake(2*ScreenWidth/3, 0, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyGroupPurchase image:@"my_group_purchase" titleText:@"我的拼团"];
    [self.bgView addSubview:myGroupPurchase];
    
    BFFuctionButton *myCoupons = [self setUpButtonWithframe:CGRectMake(0, self.height/2, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyCoupons image:@"my_coupons" titleText:@"优惠券"];
    [self.bgView addSubview:myCoupons];
    
    BFFuctionButton *myProFile = [self setUpButtonWithframe:CGRectMake(ScreenWidth/3, self.height/2, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyProFile image:@"my_proFile" titleText:@"我的资料"];
    [self.bgView addSubview:myProFile];
    
    BFFuctionButton *myPrivilege = [self setUpButtonWithframe:CGRectMake(2*ScreenWidth/3, self.height/2, ScreenWidth/3, self.height/2) type:BFFunctionButtonTypeMyPrivilege image:@"my_privilege" titleText:@"我的特权"];
    [self.bgView addSubview:myPrivilege];

    
    
}
//iicon01.png
- (BFFuctionButton *)setUpButtonWithframe:(CGRect)frame type:(BFFunctionButtonType)type image:(NSString *)image titleText:(NSString *)titleText{
    BFFuctionButton *button = [[BFFuctionButton alloc] initWithFrame:frame];
    button.tag = type;
    //button.backgroundColor = [UIColor redColor];
    button.functionImageView.image = [UIImage imageNamed:image];
    button.functionTitleLabel.text = titleText;
    [button addTarget:self action:@selector(chooseFunction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)chooseFunction:(BFFuctionButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFunction:)]) {
        [self.delegate chooseFunction:sender.tag];
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    NSUInteger count = self.bgView.subviews.count;
//    for (NSUInteger i = 0; i < count; i++) {
//        UIButton *button = self.bgView.subviews[i];
//        button.x = ScreenWidth/3 *(i%3);
//        button.y = self.height /2 *(i/3);
//        button.width = ScreenWidth/3;
//        button.width = self.height/2;
//    }
//    BFLog(@"123%@",self.bgView.subviews);
//}

@end
