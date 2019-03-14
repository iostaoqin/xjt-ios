//
//  JTBankSucessView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBankSucessView : UIView
@property (nonatomic, strong)UIImageView *bankLogoImg;
@property (nonatomic, strong)UILabel *bankNameLable;
@property (nonatomic, strong)UILabel *bankNumberNameLable;
@property (nonatomic, strong)UILabel *timeLable;
-(void)getBankModle:(JTCertificationModel *)bankModel;
@end

NS_ASSUME_NONNULL_END
