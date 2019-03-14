//
//  JTProblemTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTProblemTableViewCell.h"

@implementation JTProblemTableViewCell

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
    self.nameLable  =[UILabel new];
    self.lineLable  =[UILabel new];
    self.otherNameLable  =[UILabel new];
    self.nameDetailLable  =[UILabel new];
    self.otherDetailNameLable  =[UILabel new];
    
    [self.contentView addSubview:self.nameDetailLable];
    [self.contentView addSubview:self.otherDetailNameLable];
    [self.contentView addSubview:self.otherNameLable];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.nameLable];
    self.nameLable.layer.cornerRadius = 2;
    self.nameLable.layer.borderWidth = 1;
    self.nameLable.layer.borderColor  =[UIColor clearColor].CGColor;
    self.nameLable.layer.masksToBounds  = YES;
    self.nameLable.textColor =[UIColor whiteColor];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    //
    self.otherNameLable.layer.cornerRadius = 2;
    self.otherNameLable.layer.borderWidth = 1;
    self.otherNameLable.layer.borderColor  =[UIColor clearColor].CGColor;
    self.otherNameLable.layer.masksToBounds  = YES;
    self.otherNameLable.textColor =[UIColor whiteColor];
    self.otherNameLable.textAlignment = NSTextAlignmentCenter;
    //
    self.nameDetailLable.textColor =[UIColor colorWithHexString:@"#333333"];
    //
    self.otherDetailNameLable.textColor =[UIColor colorWithHexString:@"#999999"];
    self.otherDetailNameLable.numberOfLines=  0;
    
    self.lineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16*JT_ADAOTER_WIDTH, 16 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.contentView.mas_top).offset(16  *JT_ADAOTER_WIDTH);

        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
    }];
    [self.nameDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLable);
        make.left.equalTo(self.nameLable.mas_right).offset(8 * JT_ADAOTER_WIDTH);
    }];
    
    [self.otherNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.nameLable);
        make.top.equalTo(self.nameLable.mas_bottom).offset(14 *JT_ADAOTER_WIDTH);
    }];
    [self.otherDetailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameDetailLable);
//        make.centerY.equalTo(self.otherNameLable);
        make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
          make.top.equalTo(self.nameLable.mas_bottom).offset(14 *JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(10);
        self.otherNameLable.font  = kFontSystem(10);
        self.nameDetailLable.font  = kFontSystem(14);
         self.otherDetailNameLable.font  = kFontSystem(12);
    }else{
       self.nameLable.font  = kFontSystem(12);
        self.otherNameLable.font  = kFontSystem(12);
        self.nameDetailLable.font  = kFontSystem(16);
         self.otherDetailNameLable.font  = kFontSystem(14);
    }
}
-(void)getLeftProblemTitle:(NSArray *)nameStr leftNameColor:(NSArray *)colorStr{
    self.nameLable.text  = nameStr[0];
    self.otherNameLable.text  = nameStr[1];
    self.nameLable.backgroundColor = [UIColor colorWithHexString:colorStr[0]];
    self.nameDetailLable.text  = colorStr[1];
    self.otherNameLable.backgroundColor = [UIColor colorWithHexString:colorStr[2]];
    [self.otherDetailNameLable setText:colorStr[3] lineSpacing:6];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
