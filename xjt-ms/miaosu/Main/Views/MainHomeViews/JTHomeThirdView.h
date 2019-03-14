//
//  JTHomeThirdView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTHomeThirdView : UIView
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UIImageView *arrowImg;
@property (nonatomic, strong)UILabel *priceLable;
@property (nonatomic, strong)UILabel *leftNameLable;
@property (nonatomic, strong)UILabel *remainingNameLable;
@property (nonatomic, strong)UILabel *detailNameLable;
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *continuBtn;
-(void)getRefresh:(NSString *)showType;
-(void)getLoanModel:(JTLoanModel *)model;
@end

NS_ASSUME_NONNULL_END
