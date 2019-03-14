
//
//  JFCardNewOtherTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFCardNewOtherTableViewCell.h"

@implementation JFCardNewOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.cardNameLable  =[UILabel new];
    [self.contentView addSubview:self.cardNameLable];
    self.textViewDetail  =[UITextView new];
    [self.contentView addSubview:self.textViewDetail];
    
    self.cardNameLable.text  = @"hhhhhh";
    self.cardNameLable.font  = kFontSystem(16);
    self.cardNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.textViewDetail.font = kFontSystem(16);
    self.textViewDetail.editable  = NO;//禁止编辑
    self.textViewDetail.textColor = [UIColor colorWithHexString:@"#333333"];
    
    [self.cardNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(20*  JT_ADAOTER_WIDTH);
    }];
//    self.textViewDetail.backgroundColor =[UIColor redColor];
    [self.textViewDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.cardNameLable.mas_bottom).offset(14*  JT_ADAOTER_WIDTH);
        make.left.equalTo(self.contentView.mas_left).offset(18 *  JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-18 * JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}
-(void)getFirstData:(NSMutableArray *)cardModelArr showIndx:(NSInteger)index{
    JFThirdNewModel * cardModel  = cardModelArr[index];
    self.cardNameLable.text = cardModel.creditName;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:cardModel.detailedDesc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    self.textViewDetail.attributedText  = attributedStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
