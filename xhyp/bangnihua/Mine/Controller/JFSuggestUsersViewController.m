//
//  JFSuggestUsersViewController.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/26.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFSuggestUsersViewController.h"

@interface JFSuggestUsersViewController ()<UITextViewDelegate>
{

}
@property (nonatomic,  strong)UITextView *contentTextView;
@property (nonatomic,  strong)UILabel *contenNumberLable;
@property (nonatomic,  strong)UIButton *submitButton;
@end

@implementation JFSuggestUsersViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)leftBarButtonItemEvent:(id)sender{
    if ([self.whereVC isEqualToString:@"JFSuggestUsersViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    self.view.backgroundColor   =[UIColor colorWithHexString:@"f5f5f5"];
    [self creatTextViewControl];
}
#pragma mark - 创建输入内容的textview
-(void)creatTextViewControl{
    _contentTextView = [UITextView new];
    [self.view addSubview:_contentTextView];
    _contentTextView.delegate = self;
    _contentTextView.font = [UIFont systemFontOfSize:14];
    _contentTextView.textColor = [UIColor colorWithHexString:@"222222"];
    _contentTextView.keyboardType = UIKeyboardTypeDefault;
    _contentTextView.scrollEnabled = YES;//是否可以拖动
    _contentTextView.tintColor =  [UIColor colorWithHexString:@"999999"];
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.layer.cornerRadius =  5;
    _contentTextView.layer.borderWidth=1;
    _contentTextView.layer.borderColor  =[UIColor colorWithHexString:@"cccccc"].CGColor;
    _contentTextView.layer.masksToBounds  = YES;
    _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    __weak UIView *weakSelf = self.view;
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(25);
        make.top.equalTo(self.view.mas_top).offset(JT_NAV  + 30);
        make.right.equalTo(weakSelf.mas_right).offset(-25);
        make.height.mas_offset(180);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    //自定义placeholder
    UILabel *placeholderLable = [UILabel new];
    placeholderLable.text = @"请填写您APP遇到的问题及相关建议,我们会积极处理";
    placeholderLable.font = [UIFont systemFontOfSize:14];
    [placeholderLable setNumberOfLines:0];
    placeholderLable.textColor = [UIColor colorWithHexString:@"999999"];
    placeholderLable.enabled = NO;
    placeholderLable.backgroundColor = [UIColor clearColor];
    placeholderLable.alpha = 0;
    placeholderLable.tag = 999;
    [_contentTextView addSubview:placeholderLable];
    [placeholderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(35 *JT_ADAOTER_WIDTH);
        make.right.equalTo(weakSelf.mas_right).offset(-20*JT_ADAOTER_WIDTH);
        make.top.equalTo(self.contentTextView.mas_top).offset(10*JT_ADAOTER_WIDTH);
    }];
    if ([[_contentTextView text]length]== 0) {
        [[_contentTextView viewWithTag:999] setAlpha:1];
    }
    //设置显示字数的lable
    _contenNumberLable = [UILabel new];
    [self.view addSubview:_contenNumberLable];
    _contenNumberLable.textColor = [UIColor colorWithHexString:@"999999"];;
    _contenNumberLable.font = [UIFont systemFontOfSize:14];
    _contenNumberLable.text= @"0/150";
    [_contenNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-25);
        make.top.equalTo(self.contentTextView.mas_bottom).offset(10);
    }];
     UIButton *submitBtn  = [self.view buttonCreateWithNorStr:@"提交" nomalBgColor:@"#FF4D4F" textFont:18 cornerRadius:23];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contenNumberLable.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(330  *  JT_ADAOTER_WIDTH, 46 * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
    }];
    [submitBtn addTarget:self action:@selector(suggestionEvent) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 提交建议
-(void)suggestionEvent{
    //判断用户是否 有填写
    [_contentTextView  resignFirstResponder];
    if ([JFHSUtilsTool isBlankString:self.contentTextView.text]) {
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入您的问题或者建议!"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
      //需要 10个字以上
        if ([_contentTextView.text length] >=10) {
        NSString *suggestionStr   =[NSString stringWithFormat:@"%@/manager/bnh/feedback",HS_USER_URL];
        NSDictionary *dicStr  =@{@"appName":app_name_type,@"os":@"ios"};
       NSString  *url  = [JFHSUtilsTool conectUrl:[dicStr  mutableCopy] url:suggestionStr];
        NSDictionary  *dic =  @{@"content":self.contentTextView.text};
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"正在提交..."];
        [JFHttpsToolEdit requestType:@"POST" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
             JTLog(@"%@",data);
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                //建议成功
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"提交成功"];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    if ([self.whereVC isEqualToString:@"JFSuggestUsersViewController"]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
                
            }
        } withErrorCodeTwo:^{
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        } withErrorBlock:^(NSError * _Nonnull error) {
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
        }else{
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入您的问题或者建议,至少10个字"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            
            
        }
        
    }
}
-(void)textChange:(NSNotification *)notification{
    UITextView *textView = (UITextView *)notification.object;
    JTLog(@"%@",textView.text);
    if ([[_contentTextView text]length] == 0) {
        [[_contentTextView viewWithTag:999]setAlpha:1];
    }else{
        [[_contentTextView viewWithTag:999]setAlpha:0];
    }
    
}
#pragma mark - UItextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    [_contentTextView resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _contentTextView.editable = YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
    _contenNumberLable.text = [NSString stringWithFormat:@"%zd/150",textView.text.length];
    
}
//回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
//    NSInteger  lengCount;
//    if ([JFHSUtilsTool  isBlankString:_contentTextView.text]) {
//        lengCount  = 1;
//    }else{
//        lengCount =_contentTextView.text.length;
//    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",_contentTextView.text,text];
    if (str.length > 150) {
        _contentTextView.text = [textView.text substringToIndex:150];
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
