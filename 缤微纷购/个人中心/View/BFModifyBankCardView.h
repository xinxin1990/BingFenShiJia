//
//  BFModifyBankCardView.h
//  缤微纷购
//
//  Created by 程召华 on 16/3/9.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    BFChooseButtonTypeBank,//选择银行按钮
    BFChooseButtonTypeProvince,//选择省份按钮
    BFChooseButtonTypeCity,//选择城市按钮
    BFChooseButtonTypeBranch//选择支行按钮
}BFChooseButtonType;

@interface BFModifyBankCardView : UIView


/**银行卡号textField*/
@property (nonatomic, strong) UITextField *cardNumberTX;
/**开户人textField*/
@property (nonatomic, strong) UITextField *nameTX;
/**昵称textField*/
@property (nonatomic, strong) UITextField *nickNameTX;
/**手机号码textField*/
@property (nonatomic, strong) UITextField *telephoneTX;
@end
