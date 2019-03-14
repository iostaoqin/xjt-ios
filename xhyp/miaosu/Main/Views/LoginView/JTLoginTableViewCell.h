//
//  JTLoginTableViewCell.h
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/15.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol getCodeDelegate <NSObject>
-(void)getCodeEvent:(UIButton *)codeBtn;
@end
@interface JTLoginTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *teleImg;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UITextField *teleTextFiled;
@property (nonatomic, strong)UILabel *line;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, weak)id<getCodeDelegate>codeDelegate;
-(void)getLogiImg:(NSString *)img placeHolderText:(NSString *)str typeView:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
