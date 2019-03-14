//
//  JtDetailUsersMineTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/29.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JtDetailUsersMineTableViewCell.h"

@implementation JtDetailUsersMineTableViewCell

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
    self.nameImg = [UIImageView new];
    self.nameLable=  [UILabel new];
    self.lineLable=  [UILabel new];
    self.nameTextLable=  [UILabel new];
    self.arrowImg=  [UIImageView new];
    self.rightNameLable=  [UILabel new];
    [self.contentView addSubview:self.rightNameLable];
    [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.nameTextLable];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView  addSubview:self.nameImg];
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    self.nameLable.font  =  kFontSystem(16);
    self.nameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    
    self.nameTextLable.textColor  =[UIColor colorWithHexString:@"#FF4D4F"];
    
    self.nameTextLable.hidden  = YES;
    if (JT_IS_iPhone5) {
        self.nameTextLable.font  =  kFontSystem(14);
        self.rightNameLable.font  =  kFontSystem(14);
    }else{
        self.nameTextLable.font  =  kFontSystem(16);
        self.rightNameLable.font  =  kFontSystem(16);
    }
    //
    self.arrowImg.image =[UIImage imageNamed:@"arrow"];
    //
   
    self.rightNameLable.textColor=  [UIColor colorWithHexString:@"#999999"];
    
    [self.nameImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20 *JT_ADAOTER_WIDTH, 20 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.contentView.mas_left).offset(15*JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_right).offset(10*JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_left);
    }];
    [self.nameTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20 *JT_ADAOTER_WIDTH, 20 *JT_ADAOTER_WIDTH));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    [self.rightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    self.rightNameLable.hidden = YES;
    
    
}
-(void)getLeftImgStrArr:(NSArray *)imgStrArr showType:(NSInteger)idx{
    self.nameImg.image = [UIImage imageNamed:imgStrArr[0]];
    self.nameLable.text  =  imgStrArr[1];
    if (idx  ==0) {
        JFUserInfoTool *info =[JFUserManager shareManager].currentUserInfo;
        if ([JFHSUtilsTool isBlankString:info.certificationNumberStr]) {
            self.rightNameLable.hidden = YES;
        }else{
            if ([info.certificationNumberStr isEqualToString:@"0"]) {
                self.rightNameLable.hidden = YES;
            }else{
                self.rightNameLable.hidden = NO;
                if ([info.certificationNumberStr isEqualToString:CERICATION]) {
                    self.rightNameLable.text  =@"已认证完成";
                }else{
                      self.rightNameLable.text  = [NSString stringWithFormat:@"已认证%@项",info.certificationNumberStr];
                }
              
                
            }
        }
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
