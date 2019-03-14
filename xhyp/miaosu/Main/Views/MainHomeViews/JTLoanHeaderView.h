//
//  JTLoanHeaderView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/28.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTLoanHeaderView : UIView
@property (nonatomic, strong)UIImageView *nameImg;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *detailTipsLable;
-(void)getHeaderImg:(NSString *)logoImg  headerName:(NSString *)name detailStr:(NSString *)detail showType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
