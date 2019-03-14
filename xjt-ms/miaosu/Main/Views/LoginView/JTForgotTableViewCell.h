//
//  JTForgotTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol getForgetCodeDelegate <NSObject>
-(void)getCodeEvent:(UIButton *)codeBtn;
@end
@interface JTForgotTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UITextField *teleTextFiled;
@property (nonatomic, strong)UILabel *line;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, weak)id<getForgetCodeDelegate>forgotCodeDelegate;
-(void)getForgotNameStr:(NSString *)str placeHolderText:(NSString *)placeHolderStr typeView:(NSString *)type indexStr:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
