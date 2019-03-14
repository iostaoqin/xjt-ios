//
//  JTBankTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBankTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UIButton *supportBtn;
@property (nonatomic, strong)UITextField *rightNameTextFiled;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)UILabel *lineLable;
-(void)getLeftName:(NSString *)nameStr  placeHolderStr:(NSString *)holderStr showIndex:(NSInteger)indx;
@end

NS_ASSUME_NONNULL_END
