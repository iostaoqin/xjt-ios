//
//  JFFourthMineViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFFourthMineViewController.h"
#import "JFMineHeaderNewView.h"
#import "JFAboutOursViewController.h"
#import "JFSettingUsersViewConntroller.h"
#import "JFEditeUsersInformationViewController.h"
#import "JFDetailUsersMineTableViewCell.h"
#import "JFSuggestUsersViewController.h"
#define maxCountEDP 1 //最大照片数目
static const CGFloat portraintWidth_Height =  50;
@interface JFFourthMineViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray  *_selectedPhotos;
    NSMutableArray  *_selectedAssets;
}
@property (nonatomic, strong)JFMineHeaderNewView *firstHeaderView;
@property (nonatomic, strong)UITableView *detailTbaleView;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UIImageView   *portraintImg;
@property (nonatomic, strong)UIImagePickerController  *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic)NSArray *nameArr;
@property (nonatomic,  strong)NSString *qqStr;
@end

@implementation JFFourthMineViewController
-(void)dealloc{
    //
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginAgainNotice" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"settingSucessNotice" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
   
    self.nameArr = @[@[@"img_user",@"关于我们"],@[@"img_new_edit",@"投诉建议"],@[@"connection_img",@"联系客服(QQ)"]];
     [self headerUI];
    [self getAboutDataMine];
    //当用户没有 登录时候 不请求用户 信息
    JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        [self getUserInfo];
    }
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMineInfoNotice) name:@"loginAgainNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMineInfoNotice) name:@"settingSucessNotice" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mineDataNotice:) name:@"refreshDataNotice" object:nil];
    //
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 200);
    [self.view addSubview:button];
    button.hidden  = YES;
    
}
-(void)mineDataNotice:(NSNotification *)notice{
     NSDictionary  *dic =  notice.userInfo;
       if ([dic[@"tab_name"]isEqualToString:fourth_tab_text]) {
           
           [self getUserInfo];//请求个人 用户信息
       }
}
#pragma mark -更改用户相关信息
-(void)changeMineInfoNotice{
     JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        //未登录
        self.nameLable.text = @"请登录";
         [self.portraintImg sd_setImageWithURL:[NSURL URLWithString:userInfo.portraintUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
        
    }else{
        
        [self getUserInfo];//请求个人 用户信息
    }

}
#pragma mark -  请求关于我们获取QQ号
-(void)getAboutDataMine{
    NSString *aboutUrl= [NSString stringWithFormat:@"%@/manager/mgt/app/about",HS_USER_URL];
    NSDictionary *dic = @{@"appName":app_name_type,@"os":@"ios"};
    //拼接
    NSString *url= [JFHSUtilsTool conectUrl:[dic  mutableCopy] url:aboutUrl];
    [PPNetworkHelper GET:url parameters:dic success:^(id responseObject) {
        JTLog(@"%@",responseObject);
             if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                 //判断QQ有没有
                 if ([JFHSUtilsTool isBlankString:responseObject[@"appInfoVo"][@"qq"]]) {
                     
                 }else{
                   self.qqStr  = [NSString stringWithFormat:@"%@",responseObject[@"appInfoVo"][@"qq"]];
                 }
                 
               
             }
        [self.detailTbaleView reloadData];
    } failure:^(NSError *error) {
    
    }];
}
#pragma mark - 获取用户信息
-(void)getUserInfo{
    WEAKSELF;
    NSString *infoUrl  =[NSString stringWithFormat:@"%@/manager/bnh/user",HS_USER_URL];
    NSDictionary *dic  = @{@"detail":@"ture"};
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:infoUrl];
    
    [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.loginSuccessKey]) {
         [PPNetworkHelper setValue:user.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:url parameters:dic success:^(id responseObject) {
        JTLog(@"我的界面个人信息=%@",responseObject);
        
        JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
        //请求 成功   头像 昵称  手机号  存储
        userInfo.xteleNumberStr   = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"phoneNumber"]];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            if (![JFHSUtilsTool isBlankString:responseObject[@"user"][@"userName"]]) {
                userInfo.nameStr   =responseObject[@"user"][@"userName"];
                NSString *nameStr  =  [NSString stringWithFormat:@"%@",responseObject[@"user"][@"userName"]];
                weakSelf.nameLable.text =[JFHSUtilsTool isBlankString:nameStr]?@"未实名":nameStr;
                if (![JFHSUtilsTool isBlankString:responseObject[@"user"][@"occupation"]]||![JFHSUtilsTool isBlankString:responseObject[@"user"][@"idCard"]]||![JFHSUtilsTool isBlankString:responseObject[@"user"][@"avatarPic"]]) {
                    userInfo.professionalStr   = responseObject[@"user"][@"occupation"];
                    userInfo.identityStr   = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"idCard"]];
                    userInfo.portraintUrl   = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"avatarPic"]];
                    
                }
                
            }else{
                weakSelf.nameLable.text  = @"未实名";
            }
        [weakSelf.portraintImg sd_setImageWithURL:[NSURL URLWithString:responseObject[@"user"][@"avatarPic"]] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
        [JFUserManager shareManager].currentUserInfo  = userInfo;
        }
    } failure:^(NSError *error) {
     JTLog(@"%@",error);
    }];
}
-(void)headerUI{
    WEAKSELF;
    UIView *headerView = [UIView new];
    [self.view  addSubview:headerView];
    headerView.backgroundColor = [UIColor   whiteColor];
    headerView.frame = CGRectMake(0, 0, JT_ScreenW, 235 *  JT_ADAOTER_WIDTH);
    _firstHeaderView  = [[JFMineHeaderNewView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 120  * JT_ADAOTER_WIDTH)];
    [headerView  addSubview:_firstHeaderView];
    UIView  *portraitView =  [UIView  new];
    portraitView.backgroundColor  = [UIColor whiteColor];
    portraitView.layer.cornerRadius  = 6;
    portraitView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    portraitView.layer.shadowOffset = CGSizeMake(1, 2); portraitView.layer.shadowOpacity = 0.8f; portraitView.layer.shadowRadius = 5.0f;
    [headerView addSubview:portraitView];
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstHeaderView.titleLable.mas_bottom).offset(30 * JT_ADAOTER_WIDTH);
        make.left.equalTo(headerView.mas_left).offset(16  * JT_ADAOTER_WIDTH);
        make.right.equalTo(headerView.mas_right).offset(-16 * JT_ADAOTER_WIDTH);
        make.height.mas_equalTo(116 * JT_ADAOTER_WIDTH);
    }];
    _portraintImg = [UIImageView new];
    [portraitView addSubview:_portraintImg];
    _portraintImg.layer.cornerRadius  = portraintWidth_Height/2;
    _portraintImg.layer.masksToBounds   = YES;
    [_portraintImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(portraintWidth_Height, portraintWidth_Height));
        make.centerY.equalTo(portraitView);
        make.left.equalTo(portraitView.mas_left).offset(13 * JT_ADAOTER_WIDTH);
    }];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    [_portraintImg sd_setImageWithURL:[NSURL URLWithString:userInfo.portraintUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
    //添加手势  图片
    UITapGestureRecognizer *imgGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgGestuire)];
    _portraintImg.userInteractionEnabled =  YES;
    [_portraintImg addGestureRecognizer:imgGesture];
    
    
    UIView *nameView  =[UIView new];
    [portraitView addSubview:nameView];
  
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.portraintImg.mas_right).offset(15 * JT_ADAOTER_WIDTH);
        make.top.equalTo(portraitView.mas_top).offset(10* JT_ADAOTER_WIDTH);
        make.right.equalTo(portraitView.mas_right);
        make.height.mas_equalTo(60* JT_ADAOTER_WIDTH);
    }];
    _nameLable= [UILabel  new];
    [nameView addSubview:_nameLable];


    _nameLable.font = kFontSystem(16);
    _nameLable.textColor  = [UIColor  colorWithHexString:@"#333333"];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left);
        make.top.equalTo(portraitView.mas_top).offset(40 * JT_ADAOTER_WIDTH);
    }];
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        //未登录
        weakSelf.nameLable.text = @"请登录";
    }
    UIButton  *editBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [portraitView addSubview:editBtn];
    [editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"new_img_polygon"] forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    editBtn.titleLabel.font = kFontSystem(14);
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - editBtn.imageView.image.size.width, 0, editBtn.imageView.image.size.width)];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, editBtn.titleLabel.bounds.size.width * 6, 0, 0)];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLable.mas_left);
        make.top.equalTo(nameView.mas_bottom).offset(0 * JT_ADAOTER_WIDTH);
    }];
    [editBtn addTarget:self action:@selector(editDataEvent) forControlEvents:UIControlEventTouchUpInside];
    [_firstHeaderView.settingBtn addTarget:self action:@selector(settingBtnEvetn) forControlEvents:UIControlEventTouchUpInside];
    //tableview
    _detailTbaleView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_detailTbaleView];
    _detailTbaleView.backgroundColor   = [UIColor whiteColor];
    _detailTbaleView.delegate  = self;
    _detailTbaleView.dataSource  =self;
    _detailTbaleView.scrollEnabled = NO;
    _detailTbaleView.tableFooterView = [UIView new];
    _detailTbaleView.separatorStyle  =  UITableViewCellSeparatorStyleNone;
    CGFloat Height  =self.nameArr.count *  65  *JT_ADAOTER_WIDTH;
    [_detailTbaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(JT_ScreenW);
        make.height.mas_equalTo(Height);
        make.top.equalTo(headerView.mas_bottom);
    }];
    //
    UIImageView *emptyImge=  [UIImageView new];
    [self.view addSubview:emptyImge];
    emptyImge.image  = [UIImage imageNamed:@"new_img_mineEmpty"];
  
    [emptyImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailTbaleView.mas_bottom).offset((JT_ScreenH -  Height- headerView.frame.size.height -JT_NAV  - kTabBarHeight)/2);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(250 * JT_ADAOTER_WIDTH, 50 *JT_ADAOTER_WIDTH));
        
    }];
    //(null) 判断字符串是否为空
    UITapGestureRecognizer *nameGesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameTapGesture)];
    nameView.userInteractionEnabled = YES;
    [nameView  addGestureRecognizer:nameGesture];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65 * JT_ADAOTER_WIDTH;
}
-(UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *cell  = @"cellID";
    JFDetailUsersMineTableViewCell *detailCell  = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!detailCell) {
        detailCell = [[JFDetailUsersMineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    [detailCell getImgStrArr:self.nameArr[indexPath.row]];
    detailCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (indexPath.row  == self.nameArr.count -1) {
        
        detailCell.nameTextLable.hidden  = NO;
        detailCell.lineLable.hidden =  YES;
        detailCell.nameTextLable.text = self.qqStr;
    }else{
        detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    return detailCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath  *index =[NSIndexPath indexPathForRow:2 inSection:0];
    JFDetailUsersMineTableViewCell  *QQcell =(JFDetailUsersMineTableViewCell *)[_detailTbaleView cellForRowAtIndexPath:index];
    
    if (indexPath.row   ==0) {
        JFAboutOursViewController *aboutVc =  [[JFAboutOursViewController  alloc]init];
        aboutVc.title  =  about_me_text;
        aboutVc.hidesBottomBarWhenPushed =  YES;
        [self.navigationController  pushViewController:aboutVc animated:YES];
    }else if(indexPath.row ==1){
        //投诉建议
        [self suggestionEvent];
       
    }else{
        //长按复制QQ
        //长按(点击)复制微信号
        
        UITapGestureRecognizer * longQQPressGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleQQTap:)];
        QQcell.nameTextLable.userInteractionEnabled = YES;
        [QQcell.nameTextLable addGestureRecognizer:longQQPressGr];
    }
  
    //关于我们提交 神策数据
//    NSDictionary *dic = @{@"feature_id":@"3",@"feature_name":about_me_text};
//        [JFHSUtilsTool submitSensorsAnalytics:@"AboutPageClick" parameter:dic];
}
#pragma mark - 长按复制 QQ
-(void)handleQQTap:(UITapGestureRecognizer *)getsture{
    NSIndexPath  *index =[NSIndexPath indexPathForRow:2 inSection:0];
    JFDetailUsersMineTableViewCell  *QQcell =(JFDetailUsersMineTableViewCell *)[_detailTbaleView cellForRowAtIndexPath:index];
    [UIPasteboard generalPasteboard].string = QQcell.nameTextLable.text;
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"复制成功"];
    [[JFHudMsgTool  shareHusMsg]hiddenHud:MBProgressHUDModeText];
    
    
    
    
}
-(void)suggestionEvent{
    
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    //当用户没有登录的时候 点击编辑资料 设置界面 上传图片d按钮 均跳到登录界面
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFSuggestUsersViewController" jumVCParameter:@"" cityStr:@"" tittlName:@"" webArray:@[]];
        
    }else{
        JFSuggestUsersViewController *aboutVc =  [[JFSuggestUsersViewController  alloc]init];
        aboutVc.title  =  suggestion_me_text;
        aboutVc.hidesBottomBarWhenPushed =  YES;
        [self.navigationController  pushViewController:aboutVc animated:YES];
    }
    
   
}
#pragma mark  - 编辑资料
-(void)editDataEvent{
    WEAKSELF;
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    //当用户没有登录的时候 点击编辑资料 设置界面 上传图片d按钮 均跳到登录界面
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        //登录
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFSettingUsersViewConntroller" jumVCParameter:edit_me_text jumVCImg:self.portraintImg loginNameLable:self.nameLable];
    }else{
        //正常点击事件
        JFSettingUsersViewConntroller  *editeVC  = [[JFSettingUsersViewConntroller alloc]init];
        editeVC.hidesBottomBarWhenPushed   = YES;
        editeVC.title  =  edit_me_text;
        [editeVC setMineBlock:^(NSString *name) {
            weakSelf.nameLable.text  = name;
        }];
        [self.navigationController pushViewController:editeVC animated:YES];
    }
}
#pragma mark  - 设置
-(void)settingBtnEvetn{
    //当用户没有登录的时候 点击编辑资料 设置界面 上传图片d按钮 均跳到登录界面
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        //登录
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFEditeUsersInformationViewController" jumVCParameter:set_me_text jumVCImg:self.portraintImg loginNameLable:self.nameLable];
    }else{
        WEAKSELF;
        //正常点击事件
        JFEditeUsersInformationViewController *settingVC = [[JFEditeUsersInformationViewController  alloc]init];
        settingVC.hidesBottomBarWhenPushed   = YES;
        settingVC.title  =  set_me_text;
        [settingVC setImgBlock:^(NSString *imgUrl) {
            [weakSelf.portraintImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
        }];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    //设置提交 神策数据
//    NSDictionary *dic =@{@"feature_id":@"1",@"feature_name":set_me_text};
//        [JFHSUtilsTool submitSensorsAnalytics:@"AboutPageClick" parameter:dic];
}
-(void)tapImgGestuire{
    
    
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        //登录
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFEditeUsersInformationViewController" jumVCParameter:set_me_text jumVCImg:self.portraintImg loginNameLable:self.nameLable];
    }else{
        //正常点击事件
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        [alertVc addAction:takePhotoAction];
        UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushTZImagePickerController];
        }];
        [alertVc addAction:imagePickerAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}
#pragma mark - TZImagePickerController
-(void)pushTZImagePickerController{
    TZImagePickerController *imageVC = [[TZImagePickerController alloc]initWithMaxImagesCount:maxCountEDP columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    //允许内部拍照
    imageVC.allowTakePicture = NO;
    imageVC.sortAscendingByModificationDate = NO;//拍照在第一个位置
    //允许选择原图
    imageVC.allowPickingOriginalPhoto = YES;
    //不允许选择视频
    imageVC.allowPickingVideo = NO;
    //允许选择照片
    imageVC.allowPickingImage = YES;
    imageVC.showSelectBtn = NO;
    imageVC.sortAscendingByModificationDate = NO;
    [imageVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imageVC animated:YES completion:nil];
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        //        if (self.showTakeVideoBtnSwitch.isOn) {
        //            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        //        }
        //        if (self.showTakePhotoBtnSwitch.isOn) {
        //            [mediaTypes addObject:(NSString *)kUTTypeImage];
        //        }
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //    tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [self submit:image];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    //更新头像
    //    _portraintImg.image =  photos[0];
    [self submit:photos[0]];
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
}
#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}
#pragma mark  - 提交头像图片
-(void)submit:(UIImage *)img{
    WEAKSELF;
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"更改中..."];
    NSString *img_url = [NSString stringWithFormat:@"%@/manager/bnh/files/user",HS_USER_URL];
     NSDictionary *dic  = @{@"os":@"ios",@"appName":app_name_type};
    NSObject * responese = [self jamUploadImage:img_url params:[dic  mutableCopy] imageL:img];
    if (responese != nil) {
        NSDictionary * dic =(NSDictionary *)responese;
        if ([dic[@"resultCode"] integerValue] == 0) {
            //上传成功
            //延迟消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                //修改当前的显示
                weakSelf.portraintImg.image=  img;
            });
            userInfo.portraintUrl  =dic[@"fileName"];
            [JFUserManager shareManager].currentUserInfo = userInfo;
            
        }else {
            //上传失败
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            JTLog(@"上传失败");
        }
    }else {
        //上传错误
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        JTLog(@"上传错误");
    }
}
- (NSDictionary *)jamUploadImage:(NSString *)url params:(NSMutableDictionary*)postParems imageL:(UIImage *)image {
    //根据url 初始化 request
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    NSString *TWITTERFON_FORM_BOUNDARY = @"--WebKitFormBoundaryqRL9PfS8f0kLqJF0";
    //根据url初始化request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    
    //分割线
    NSString *MPboundary = [NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符
    //    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到的图片data
    NSData *data =   UIImageJPEGRepresentation(image, 0.05);
    //        NSData *data = UIImagePNGRepresentation(image);
    //http body 的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //参数的集合的所有key的集合
    NSArray * keys = [postParems allKeys];
    //便利keys
    for (NSInteger i = 0 ; i < keys.count; i++) {
        //得到当前的 key
        NSString * key = keys[i];
        //添加分界线 换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    //添加分界线 换行
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",@"file",@"filename.jpg"];
    //生命上传文件的格式
    [body appendFormat:@"Content-Type: image/jpg,image/png, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    //生命结束符
    //    NSString * end  = [[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary ];
    
    //声明myRequestData  用来 放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    //    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    
    //加入结束符
    //    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content =[[NSString alloc]initWithFormat:@"application/octet-stream; boundary=%@",TWITTERFON_FORM_BOUNDARY ];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:userInfo.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    //设置 Content-Length
    [request  setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //设置 http method
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    //    NSString * result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSError * err = [[NSError alloc]init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&err];
    
    
    if ([urlResponese statusCode] >= 200 && [urlResponese statusCode]< 300) {
        return  dic;
    }else {
        return nil;
    }
}
#pragma mark -  姓名/请登录
-(void)nameTapGesture{
    WEAKSELF;
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
        
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFBigNewEditViewController" jumVCParameter:@"" cityStr:@"" tittlName:@""webArray:@[]];
    }else{
        //跳到编辑界面
        JFSettingUsersViewConntroller  *editeVC  = [[JFSettingUsersViewConntroller alloc]init];
        editeVC.hidesBottomBarWhenPushed   = YES;
        editeVC.title  =  edit_me_text;
        [editeVC setMineBlock:^(NSString *name) {
            weakSelf.nameLable.text  = name;
        }];
        [self.navigationController pushViewController:editeVC animated:YES];
    }
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
