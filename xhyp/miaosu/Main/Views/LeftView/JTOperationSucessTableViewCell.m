//
//  JTOperationSucessTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTOperationSucessTableViewCell.h"

@implementation JTOperationSucessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameLable =[UILabel new];
    self.otherNameLable =[UILabel new];
    self.logoImg =[UIImageView new];
    [self.contentView addSubview:self.logoImg];
    [self.contentView addSubview:self.otherNameLable];
    [self.contentView addSubview:self.nameLable];
    //
    self.otherNameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    self.nameLable.textColor =[UIColor colorWithHexString:@"#999999"];
    
    if (JT_IS_iPhone5) {
        self.nameLable.font = kFontSystem(12);
         self.otherNameLable.font = kFontSystem(12);
    }else{
        self.nameLable.font = kFontSystem(14);
        self.otherNameLable.font = kFontSystem(14);
    }
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(100 *JT_ADAOTER_WIDTH);
    }];
    
    [self.otherNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLable.mas_right).offset(40 *JT_ADAOTER_WIDTH);
    }];
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18 *JT_ADAOTER_WIDTH, 18 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.otherNameLable.mas_right).offset(10 *JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.otherNameLable);
    }];
    self.logoImg.hidden = YES;
}
-(void)getLtftNameStr:(NSString *)nameStr rightNameStr:(JTCertificationModel *)rightModel showTypeIdx:(NSInteger)idx  type:(NSInteger)typeID {
    self.nameLable.text = nameStr;
    if (typeID ==4) {
        //实名认证成功
     NSString *reasonstr=   [JFHSUtilsTool isBlankString:rightModel.failReason]?@"":rightModel.failReason;
    NSString  *str  = [rightModel.realnameVerified isEqualToString:@"1"]?@"审核通过":[rightModel.realnameVerified isEqualToString:@"2"]?reasonstr:reasonstr;
    NSString *colorName  =[rightModel.realnameVerified isEqualToString:@"1"]?@"#62A7E9":[rightModel.realnameVerified isEqualToString:@"2"]?@"#FF4D4F":@"#FF4D4F";
    
        
        
    NSArray *rightArr  = @[[JFHSUtilsTool isBlankString:rightModel.idName]?@"":rightModel.idName,[JFHSUtilsTool isBlankString:rightModel.idNumber]?@"":rightModel.idNumber, [JFHSUtilsTool isBlankString:rightModel.validityPeriod]?@"":rightModel.validityPeriod,str,rightModel.creationDate,rightModel.realnameVerifiedDate];
        self.otherNameLable.text = rightArr[idx];
        if ([rightModel.realnameVerified isEqualToString:@"1"]) {
            self.logoImg.image= [UIImage imageNamed:@"Operator_success"];
        }else{
            self.logoImg.image= [UIImage imageNamed:@"info_fill"];
        }
    if (idx  ==3) {
        self.logoImg.hidden = NO;
        self.otherNameLable.textColor  =[UIColor colorWithHexString:colorName];
    }
    }else{
        //运营商认证成功
        self.logoImg.image= [UIImage imageNamed:@"Operator_success"];
        NSString  *str  = [rightModel.mobileVerified isEqualToString:@"1"]?@"审核通过":[rightModel.mobileVerified isEqualToString:@"2"]?@"审核失败":@"已过期";
        NSArray  *moilNameArr = @[rightModel.phoneNumber,@"已上传",str,rightModel.creationDate,rightModel.mobileVerifiedDate];
        NSString *colorName  =[rightModel.mobileVerified isEqualToString:@"1"]?@"#62A7E9":[rightModel.mobileVerified isEqualToString:@"2"]?@"#FF4D4F":@"#FF4D4F";
         self.otherNameLable.text = moilNameArr[idx];
        if (idx  ==2) {
            self.logoImg.hidden = NO;
            self.otherNameLable.textColor  =[UIColor colorWithHexString:colorName];
        }
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
