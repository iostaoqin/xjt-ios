//
//  JFDetailInformationNewTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFDetailInformationNewTableViewCell.h"

@implementation JFDetailInformationNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameLable  = [UILabel new];
    self.nameTextFiled  = [UITextField new];
    self.focusImg  = [UIImageView new];
    self.lineLable  = [UILabel new];
    [self.contentView addSubview:self.nameTextFiled];
    [self.contentView addSubview:self.nameLable];
     [self.contentView addSubview:self.focusImg];
    [self.contentView addSubview:self.lineLable];
    
    //
    self.nameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.nameLable.font  = kFontSystem(16);
    self.nameTextFiled.font  = kFontSystem(16);
    [_nameTextFiled setValue:[UIColor colorWithHexString:@"#CCCCCC"] forKeyPath:@"_placeholderLabel.textColor"];
    self.nameTextFiled.placeholder = @"请选择";
    self.nameTextFiled.textAlignment  = NSTextAlignmentRight;
    self.focusImg.image =[UIImage imageNamed:@"new_img_focus"];
    self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(19* JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.focusImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_equalTo(0);
        make.left.equalTo(self.nameLable.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.width.mas_equalTo(200 * JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
//        make.width.mas_equalTo(JT_ScreenW);
        make.left.equalTo(self.nameLable.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}
-(void)getNameData:(JFEditHomeDetailModel *)nameModel userInfoArr:(NSMutableArray *)arr{
    self.nameLable.text = nameModel.desc;
    if (nameModel.required == YES) {
            [self.focusImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
    }
    JTLog(@"%@",nameModel.fieldName);
    for (JFEditHomemodel *model in arr) {
        if ([model.name isEqualToString:nameModel.fieldName]) {
            JTLog(@"%@",model.value);
            self.nameTextFiled.text  = model.value;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
