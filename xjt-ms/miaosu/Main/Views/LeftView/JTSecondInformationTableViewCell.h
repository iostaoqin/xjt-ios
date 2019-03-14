//
//  JTSecondInformationTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol secondInformationDelegate <NSObject>
-(void)selectedConnectEventClick:(UIButton *)btn;
@end
@interface JTSecondInformationTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *nameLable;
@property(nonatomic, strong)UITextField *addressTextField;
@property(nonatomic, strong)UILabel *verticalImg;
@property(nonatomic, strong)UILabel *lineLable;
@property(nonatomic, strong)UIButton *selectedBtn;
@property(nonatomic, strong)UILabel *teleLable;
@property (nonatomic,weak)id<secondInformationDelegate>informationDelegate;
-(void)getLeftNameStr:(NSString *)nameStr nameIdx:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
