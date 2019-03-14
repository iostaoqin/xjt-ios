//
//  JTMessageCenterTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTMessageCenterTableViewCell.h"

@implementation JTMessageCenterTableViewCell

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
    self.bgView = [UIView new];
    self.messageLogoImg  =[UIImageView new];
    self.tipsNameLable  =[UILabel new];
    self.timeLable  =[UILabel new];
    self.firstLineLable  =[UILabel new];
    self.detailNameLable  =[UILabel new];
    self.secondLineLable  =[UILabel new];
    self.continuBtn  =[UIButton new];
    //
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.tipsNameLable];
    [self.bgView addSubview:self.timeLable];
    [self.bgView addSubview:self.firstLineLable];
    [self.bgView addSubview:self.messageLogoImg];
    [self.bgView addSubview:self.secondLineLable];
    [self.bgView addSubview:self.detailNameLable];
    [self.bgView addSubview:self.continuBtn];
    //
    self.bgView.backgroundColor  =[UIColor whiteColor];
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 5); self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.shadowRadius = 5.0f;
    //
   
    //
    
    self.tipsNameLable.textColor =[UIColor colorWithHexString:@"#333333"];
   
    self.timeLable.textColor =[UIColor colorWithHexString:@"#999999"];
    
    self.detailNameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    self.detailNameLable.numberOfLines  = 0;
    [self.continuBtn setTitle:@"继续认证>>" forState:UIControlStateNormal];
    [self.continuBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
    self.firstLineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    self.secondLineLable.backgroundColor   =[UIColor colorWithHexString:@"#EEEEEE"];
    [self makeConstraints];
    if (JT_IS_iPhone5) {
        self.tipsNameLable.font  = kFontSystem(12);
        self.timeLable.font  = kFontSystem(8);
        self.detailNameLable.font  = kFontSystem(12);
        self.continuBtn.titleLabel.font  = kFontSystem(12);
    }else{
         self.tipsNameLable.font  = kFontSystem(14);
        self.timeLable.font  = kFontSystem(10);
        self.detailNameLable.font  = kFontSystem(14);
        self.continuBtn.titleLabel.font  = kFontSystem(14);
    }
  
}
-(void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.height.equalTo(self.contentView);
    }];
    [self.messageLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18 *JT_ADAOTER_WIDTH, 18 *JT_ADAOTER_WIDTH));
        make.left.mas_equalTo(self.bgView.mas_left).offset(10* JT_ADAOTER_WIDTH);
        make.top.equalTo(self.bgView.mas_top).offset(10  * JT_ADAOTER_WIDTH);
    }];
    [self.tipsNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageLogoImg.mas_right).offset(5);
        make.centerY.equalTo(self.messageLogoImg);
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageLogoImg);
        make.right.equalTo(self.bgView.mas_right).offset(-10 *JT_ADAOTER_WIDTH);
    }];
    [self.firstLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.messageLogoImg.mas_bottom).offset(10);
    }];
    [self.detailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLineLable.mas_bottom).offset(15 *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.messageLogoImg.mas_left);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
//        make.centerY.equalTo(self.contentView).offset(20 * JT_ADAOTER_WIDTH);
    }];
//    [self.secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.left.right.equalTo(self.detailNameLable);
//        make.top.equalTo(self.detailNameLable.mas_bottom).offset(10);
//    }];
//    [self.continuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.secondLineLable.mas_bottom).offset(10);
//        make.centerX.equalTo(self.bgView);
//    }];
}
-(void)getMessagedata:(JTMessageModel *)messageModel{
    self.tipsNameLable.text  = messageModel.subject;
//    self.detailNameLable.text  = messageModel.messageText;
     self.timeLable.text  = [JFHSUtilsTool getDateStringWithTimeStr:messageModel.sendDate showType:@"yyyy-MM-dd  HH:mm:ss"];;
    [self.detailNameLable  setText:messageModel.messageText lineSpacing:6];
   //1.所有认证 2.借款到账成功 3.明/今日到期 4.已拒绝,放款失败 5.已逾期 6.审核通过 7.已还款
    NSString *typeImg =[messageModel.messageType isEqualToString:@"1"]?@"Allcertification":[messageModel.messageType isEqualToString:@"2"]?@"Borrowingsuccessful":[messageModel.messageType isEqualToString:@"3"]?@"tomorrow":[messageModel.messageType isEqualToString:@"4"]?@"refused":[messageModel.messageType isEqualToString:@"5"]?@"info_fill":[messageModel.messageType isEqualToString:@"6"]?@"applyStutes":@"Operator_success";
  
    self.messageLogoImg.image =[UIImage imageNamed:typeImg];
  
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
