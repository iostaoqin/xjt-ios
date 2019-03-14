//
//  JFCardNewEditTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFCardNewEditTableViewCell.h"

@implementation JFCardNewEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.nameLable  = [UILabel new];
    self.nameTextFiled  = [UITextField new];
    self.lineLable  = [UILabel new];
    [self.contentView addSubview:self.nameTextFiled];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.lineLable];
   
    self.nameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.nameLable.font  = kFontSystem(17);
    self.nameTextFiled.font  = kFontSystem(17);
     [_nameTextFiled setValue:[UIColor colorWithHexString:@"#CCCCCC"] forKeyPath:@"_placeholderLabel.textColor"];
    self.nameTextFiled.placeholder = @"请填写";
    self.nameTextFiled.textAlignment  = NSTextAlignmentRight;
     self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(19* JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-17* JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(200 * JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.nameLable.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}
-(void)getNameText:(NSString *)name detailTextStr:(NSString *)textStr placeTitle:(nonnull NSString *)placeStr{
    self.nameLable.text  = name;
    if (![JFHSUtilsTool isBlankString:textStr]) {
        self.nameTextFiled.text = textStr;
    }else{
        self.nameTextFiled.placeholder  = placeStr;
    }
}
-(void)getNameModel:(JFEditHomeDetailModel *)nameModel detailTextStr:(NSString *)textStr {
    //城市可以再次选择修改
    self.nameTextFiled.enabled  = [nameModel.type isEqualToString:@"1"]?YES:NO;
    
    if ([JFHSUtilsTool isBlankString:textStr]) {
     self.nameTextFiled.placeholder = @"请填写";
    }else{
        self.nameTextFiled.text = textStr;
    }
    NSString *str;
    if ( [nameModel.fieldName isEqualToString:@"loanAmount"]) {
        str =[NSString stringWithFormat:@"%@(元)",nameModel.desc];
    }else if([nameModel.fieldName isEqualToString:@"loanPeriod"]){
        str =[NSString stringWithFormat:@"%@(月)",nameModel.desc];
    }else{
        str  = nameModel.desc;
    }
    self.nameLable.text = str;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
