//
//  JFEditeUsersInformationViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/29.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFEditeUsersInformationViewController.h"
#define maxCountEDP 1 //最大照片数目
static const CGFloat portraintWidth_Height =  50;
@interface JFEditeUsersInformationViewController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray  *_selectedPhotos;
    NSMutableArray  *_selectedAssets;
}
@property  (nonatomic, strong)UIImageView *teleImg;
@property  (nonatomic,  strong)UIImageView *portraintImg;
@property (nonatomic, strong)UIImagePickerController  *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UILabel *teleLable;
@end
@implementation JFEditeUsersInformationViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginAgainNotice" object:nil];
}
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self setportraintUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeInfoNotice) name:@"loginAgainNotice" object:nil];
}
-(void)changeInfoNotice{
    JFUserInfoTool *latestUser  = [JFUserManager shareManager].currentUserInfo;
     [_portraintImg sd_setImageWithURL:[NSURL URLWithString:latestUser.portraintUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
     NSString *numberString = [latestUser.xteleNumberStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _teleLable.text  = numberString;
}
-(void)setportraintUI{
    WEAKSELF;
    JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
    UIView *headerView  = [UIView new];
    [self.view  addSubview:headerView];
    headerView.backgroundColor  = [UIColor whiteColor];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(JT_NAV);
        make.width.mas_equalTo(JT_ScreenW);
        make.height.mas_equalTo(100 * JT_ADAOTER_WIDTH);
    }];
    _portraintImg  = [UIImageView new];
    [headerView addSubview:_portraintImg];
    _portraintImg.layer.cornerRadius  = portraintWidth_Height/2;
    _portraintImg.layer.masksToBounds  = YES;
    [_portraintImg sd_setImageWithURL:[NSURL URLWithString:userInfo.portraintUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
    [_portraintImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(portraintWidth_Height, portraintWidth_Height));
        make.center.equalTo(headerView);
    }];
    //headerView添加手势
//    UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(portraintGesture)];
//    headerView.userInteractionEnabled   =  YES;
//    [headerView addGestureRecognizer:gesture];
    //detailView
    UIView *detailView = [UIView new];
    [self.view  addSubview:detailView];
    detailView.backgroundColor  = [UIColor  whiteColor];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(65);
        make.top.equalTo(headerView.mas_bottom);
        make.width.mas_equalTo(JT_ScreenW);
    }];
    UILabel *line =  [UILabel new];
    [detailView addSubview:line];
    line.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(JT_ScreenW);
        make.height.mas_equalTo(1);
        make.top.equalTo(detailView.mas_top);
    }];
    _teleImg   = [UIImageView new];
    [detailView addSubview:_teleImg];
    _teleImg.image= [UIImage imageNamed:@"new_img_mobile"];
    [_teleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(detailView);
        make.left.equalTo(detailView.mas_left).offset(16 * JT_ADAOTER_WIDTH);
    }];
    UILabel *nameLable =  [UILabel new];
    [detailView addSubview:nameLable];
    nameLable.text  = @"手机号码";
    nameLable.font  = kFontSystem(16);
    nameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detailView);
        make.left.equalTo(weakSelf.teleImg.mas_right).offset(13 * JT_ADAOTER_WIDTH);
    }];
    _teleLable   = [UILabel new];
    [detailView  addSubview:_teleLable];
    _teleLable.font  = kFontSystem(16);
    _teleLable.textColor  = [UIColor  colorWithHexString:@"#999999"];
    NSString *numberString = [userInfo.xteleNumberStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _teleLable.text = numberString;
    [_teleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detailView);
        make.right.equalTo(detailView.mas_right).offset(-24 * JT_ADAOTER_WIDTH);
    }];
 
    UIButton *exitBtn  = [self.view buttonCreateWithNorStr:exit_login_text nomalBgColor:@"#FF4D4F" textFont:18 cornerRadius:23];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343 *  JT_ADAOTER_WIDTH, 46 * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
        make.top.equalTo(detailView.mas_bottom).offset(44 * JT_ADAOTER_WIDTH);
    }];
    [exitBtn addTarget:self action:@selector(exitBtnEventClick) forControlEvents:UIControlEventTouchUpInside];
   
}
#pragma mark - 更换头像
-(void)portraintGesture{
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
#pragma mark -  退出登录
-(void)exitBtnEventClick{
    //退出登录  清空之前保存的
      UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JFUserInfoTool *userInfo =[[JFUserInfoTool alloc]init];
        [JFUserManager shareManager].currentUserInfo= userInfo;
        JFUserLoginViewController *loginVC =  [[JFUserLoginViewController alloc]init];
        loginVC.jumControllerVC  = @"JFEditeUsersInformationViewController";
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        //当用户退出登录之后到登录界面直接返回
          [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAgainNotice" object:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [exitAlert addAction:cancelAction];
    [exitAlert addAction:sureAction];
    [self presentViewController:exitAlert animated:YES completion:nil];
   
}
-(void)leftBarButtonItemEvent:(id)sender{
    if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
    JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"更改中..."];
    NSString *img_url = [NSString stringWithFormat:@"%@/manager/bnh/files/user",HS_USER_URL];
    NSDictionary *dic = @{@"os":@"ios",@"appName":app_name_type};
    NSObject * responese = [self jamUploadImage:img_url params:[dic mutableCopy] imageL:img];
    if (responese != nil) {
        NSDictionary * dic =(NSDictionary *)responese;
        if ([dic[@"resultCode"] integerValue] == 0) {
            //上传成功
            //延迟消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                weakSelf.portraintImg.image=  img;
            });
            userInfo.portraintUrl =dic[@"fileName"];
            //修改当前的显示
            self.imgBlock(dic[@"fileName"]);
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
    JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
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
@end
