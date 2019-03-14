//
//  JTLeftViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLeftViewController.h"
#import "JtDetailUsersMineTableViewCell.h"
#import "JTLoginLeftView.h"
#import "JTRegistedViewController.h"
#import "JTSettingViewController.h"
#import "JTAboutViewController.h"
#import "JTCertificationViewController.h"
#import "JTContactViewController.h"
#import "JTProblemViewController.h"
#define maxCountEDP 1 //最大照片数目
@interface JTLeftViewController ()<UITableViewDelegate,UITableViewDataSource,submitPortraintDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray  *_selectedPhotos;
    NSMutableArray  *_selectedAssets;
}
@property (nonatomic, strong)UITableView *leftTableView;
@property (strong, nonatomic)NSArray *nameArr;
@property (nonatomic, strong)UIImagePickerController  *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong)JTLoginLeftView *headerView;
@end

@implementation JTLeftViewController
-(void)dealloc{
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"exitLoginSucessNotice" object:nil];
      [[NSNotificationCenter defaultCenter]removeObserver:self name:@"persoalDataSucessNotice" object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"certificationSucessNotice" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.nameArr = @[@[@"certification",@"认证中心"],@[@"problem",@"常见问题"],@[@"customer",@"联系我们"],@[@"setting",@"设置"],@[@"aboutMe",@"关于我们 "]];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self leftTableViewUI];
    [self headerViewUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitLoginSucessNoticeNoticeEvent) name:@"exitLoginSucessNotice" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(persoalDataSucessNoticeEvent) name:@"persoalDataSucessNotice" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(persoalDataSucessNoticeEvent) name:@"certificationSucessNotice" object:nil];
    
    
    if (@available(iOS 11.0, *)) {
        _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)leftTableViewUI
{
    self.leftTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 310 * JT_ADAOTER_WIDTH, JT_ScreenH) style:UITableViewStylePlain];
    [self.view addSubview:self.leftTableView];
    self.leftTableView.delegate  = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView =[UIView new];
    self.leftTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.leftTableView.backgroundColor =[UIColor clearColor];
}

-(void)headerViewUI{
    _headerView =[JTLoginLeftView new];
    self.leftTableView.tableHeaderView= _headerView;
    _headerView.portraintImgDelegate = self;
    _headerView.frame  = CGRectMake(0, 0, self.view.frame.size.width, 235*JT_ADAOTER_WIDTH);
}
#pragma mark - 请求个人信息成功 之后刷新数据 || 认证成功之后刷新对应的cell
-(void)persoalDataSucessNoticeEvent{
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.userNameStr]) {
        _headerView.nameImg.hidden  = YES;
        _headerView.nameLable.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
    }else{
        _headerView.nameImg.hidden  = YES;
        _headerView.nameLable.text = userInfo.userNameStr;
        _headerView.teleLable.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
    }
    //刷新cell
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -  退出登录 
-(void)exitLoginSucessNoticeNoticeEvent{

    _headerView.nameLable.text  = @"去登陆";
    _headerView.nameImg.hidden  = NO;
    _headerView.teleLable.text = @"";
  //刷新cell
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.nameArr.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cellID";
    JtDetailUsersMineTableViewCell *leftCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!leftCell) {
        leftCell  =[[JtDetailUsersMineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row ==self.nameArr.count-1) {
        leftCell.lineLable.hidden  = YES;
    }
    leftCell.backgroundColor  =[UIColor whiteColor];
    leftCell.selectionStyle= UITableViewCellSelectionStyleNone;
    [leftCell getLeftImgStrArr:self.nameArr[indexPath.row]showType:indexPath.row];
    return leftCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFUserInfoTool *info  =[JFUserManager shareManager].currentUserInfo;
    switch (indexPath.row) {
        case 0:
        {
           //认证中心
            //先判断用户是否登录
            if ([JFHSUtilsTool isBlankString:info.keyStr]) {
                JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
                JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:nav animated:YES completion:nil];
                [self.sideMenuViewController hideMenuViewController];
            }else{
                 [(UINavigationController *)self.sideMenuViewController.contentViewController pushViewController:[[JTCertificationViewController alloc] init] animated:YES];
            }
            
        }
            break;
        case 3:
        {
            //设置
            if ([JFHSUtilsTool isBlankString:info.keyStr]) {
                JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
                JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:nav animated:YES completion:nil];
                [self.sideMenuViewController hideMenuViewController];
            }else{
                [(UINavigationController *)self.sideMenuViewController.contentViewController pushViewController:[[JTSettingViewController alloc] init] animated:YES];
            }
        }
            break;
        case 1:
        {
            //常见问题
            [(UINavigationController *)self.sideMenuViewController.contentViewController pushViewController:[[JTProblemViewController  alloc] init] animated:YES];
        }
            break;
            case 2:
        {
            //联系我们
            [(UINavigationController *)self.sideMenuViewController.contentViewController pushViewController:[[JTContactViewController alloc] init] animated:YES];
        }
            break;
        default:
        {
          
            //关于我们
            [(UINavigationController *)self.sideMenuViewController.contentViewController pushViewController:[[JTAboutViewController alloc] init] animated:YES];
           
        }
            break;
    }
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark - 上传头像
-(void)portraintImgClick{
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //说明用户没登录过
        JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
        JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
    }else{
    //正常点击事件
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self takePhoto];
//    }];
//    [alertVc addAction:takePhotoAction];
//    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self pushTZImagePickerController];
//    }];
//    [alertVc addAction:imagePickerAction];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVc addAction:cancelAction];
//    [self presentViewController:alertVc animated:YES completion:nil];
    }
}
#pragma mark -去登陆
-(void)gotoLoginClick{
    //先判断用户是否已经登录过   若已经登录  直接 显示名称即可 否则登录
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //说明用户没登录过
        JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
        JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
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
//    [self submit:image];
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
//    [self submit:photos[0]];
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


@end
