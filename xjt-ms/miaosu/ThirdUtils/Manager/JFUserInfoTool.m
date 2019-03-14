//
//  JFUserInfoTool.m
//  petassistant
//
//  Created by Daisy  on 2018/10/10.
//  Copyright © 2018年 com.wp. All rights reserved.
//

#import "JFUserInfoTool.h"

#define JTKeyStr                       @"keyStr"
#define JTxuserloginIdStr              @"xuserloginIdStr"
#define JTxteleNumberStr               @"xteleNumberStr"
#define JTUserNameStr                  @"userNameStr"
#define JTCertificationNumberStr       @"certificationNumberStr"
#define JTIdCardStr                    @"idCardStr"
#define JTOperatorTimeStr              @"operatorTimeStr"

//贷超
#define HSSetOpenPW                        @"openPW"
#define HSSetLimitStr                      @"limitStr"
#define HSSetOverheadStr                   @"overheadStr"
#define HSSetCategoryStr                   @"categoryStr"

#define HSSetOtherPriceStr                      @"otherPriceStr"
#define HSSetTrafficPriceStr                    @"trafficPriceStr"
#define HSSetfoodPriceStr                       @"foodPriceStr"
#define HSSetHealthPriceStr                     @"healthPriceStr"
#define HSSetFreePriceStr                       @"freePriceStr"
#define HSCountStr                              @"countStr"
#define HSMonthPriceStr                         @"monthPriceStr"
#define HSColorArray                            @"colorArray"
#define HSManagerPriceArray                     @"managerPriceArray"
//帮你花
#define HSLoginSuccessKey                      @"loginSuccessKey"
//#define HSUserId                               @"userId"
#define HSTeleStr                              @"teleStr"
#define HSNameStr                              @"nameStr"
#define HSIdentityStr                          @"identityStr"
#define HSProfessionalStr                      @"professionalStr"
#define HSHeaderModelStr                       @"headerModelStr"
#define HSChannelCodeStr                       @"channelCodeStr"
#define HSUserIdStr                            @"userIdStr"
#define HSPortraintUrlStr                      @"portraintUrl"
#define HSPortraintImg                         @"portraintImg"
#define HSSixStr                               @"sixStr"
#define HSBirthdayStr                          @"birthdayStr"

@implementation JFUserInfoTool
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_keyStr forKey:JTKeyStr];
    [aCoder encodeObject:_xuserloginIdStr forKey:JTxuserloginIdStr];
    [aCoder encodeObject:_xteleNumberStr forKey:JTxteleNumberStr];
    [aCoder encodeObject:_userNameStr forKey:JTUserNameStr];
    [aCoder encodeObject:_certificationNumberStr forKey:JTCertificationNumberStr];
    [aCoder encodeObject:_idCardStr forKey:JTIdCardStr];
    //贷超
    [aCoder encodeObject:_openPW forKey:HSSetOpenPW];
    [aCoder encodeObject:_limitStr forKey:HSSetLimitStr];
    [aCoder encodeObject:_categoryStr forKey:HSSetCategoryStr];
    [aCoder encodeObject:_overheadStr forKey:HSSetOverheadStr];
    //
    [aCoder encodeObject:_otherPriceStr forKey:HSSetOtherPriceStr];
    [aCoder encodeObject:_trafficPriceStr forKey:HSSetTrafficPriceStr];
    [aCoder encodeObject:_healthPriceStr forKey:HSSetHealthPriceStr];
    [aCoder encodeObject:_freePriceStr forKey:HSSetFreePriceStr];
    [aCoder encodeObject:_foodPriceStr forKey:HSSetfoodPriceStr];
    [aCoder encodeObject:_countStr forKey:HSCountStr];
    [aCoder encodeObject:_monthPriceStr forKey:HSMonthPriceStr];
    [aCoder encodeObject:_colorArray forKey:HSColorArray];
    [aCoder encodeObject:_managerPriceArray forKey:HSManagerPriceArray];
    //    [aCoder encodeObject:_userId forKey:HSUserId];
    [aCoder encodeObject:_loginSuccessKey forKey:HSLoginSuccessKey];
    [aCoder encodeObject:_teleStr forKey:HSTeleStr];
    [aCoder encodeObject:_nameStr forKey:HSNameStr];
    [aCoder encodeObject:_identityStr forKey:HSIdentityStr];
    [aCoder encodeObject:_professionalStr forKey:HSProfessionalStr];
    [aCoder encodeObject:_headerModelStr forKey:HSHeaderModelStr];
    [aCoder encodeObject:_channelCodeStr forKey:HSChannelCodeStr];
    [aCoder encodeObject:_userIdStr forKey:HSUserIdStr];
    [aCoder encodeObject:_portraintUrl forKey:HSPortraintUrlStr];
    [aCoder encodeObject:_portraintImg forKey:HSPortraintImg];
    [aCoder encodeObject:_sixStr forKey:HSSixStr];
    [aCoder encodeObject:_birthdayStr forKey:HSBirthdayStr];
     [aCoder encodeObject:_operatorTimeStr forKey:JTOperatorTimeStr];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _xuserloginIdStr                  = [aDecoder decodeObjectForKey:JTxuserloginIdStr];
        _keyStr                         = [aDecoder decodeObjectForKey:JTKeyStr];
        _xteleNumberStr                  = [aDecoder decodeObjectForKey:JTxteleNumberStr];
         _userNameStr                    = [aDecoder decodeObjectForKey:JTUserNameStr];
          _certificationNumberStr          = [aDecoder decodeObjectForKey:JTCertificationNumberStr];
         _idCardStr                      = [aDecoder decodeObjectForKey:JTIdCardStr];
        //贷超
        _openPW                         = [aDecoder decodeObjectForKey:HSSetOpenPW];
        _limitStr                       = [aDecoder decodeObjectForKey:HSSetLimitStr];
        _categoryStr                     = [aDecoder decodeObjectForKey:HSSetCategoryStr];
        _overheadStr                     = [aDecoder decodeObjectForKey:HSSetOverheadStr];
        //
        _otherPriceStr                   = [aDecoder decodeObjectForKey:HSSetOtherPriceStr];
        _trafficPriceStr                 = [aDecoder decodeObjectForKey:HSSetTrafficPriceStr];
        _healthPriceStr                  = [aDecoder decodeObjectForKey:HSSetHealthPriceStr];
        _freePriceStr                    = [aDecoder decodeObjectForKey:HSSetFreePriceStr];
        _foodPriceStr                    = [aDecoder decodeObjectForKey:HSSetfoodPriceStr];
        _countStr                       = [aDecoder decodeObjectForKey:HSCountStr];
        _monthPriceStr                   = [aDecoder decodeObjectForKey:HSMonthPriceStr];
        _colorArray                      = [aDecoder decodeObjectForKey:HSColorArray];
        _managerPriceArray                = [aDecoder decodeObjectForKey:HSManagerPriceArray];
        _loginSuccessKey                 = [aDecoder decodeObjectForKey:HSLoginSuccessKey];
        _teleStr             = [aDecoder decodeObjectForKey:HSTeleStr];
        _nameStr             = [aDecoder decodeObjectForKey:HSNameStr];
        _identityStr          = [aDecoder decodeObjectForKey:HSIdentityStr];
        _professionalStr       = [aDecoder decodeObjectForKey:HSProfessionalStr];
        _headerModelStr       = [aDecoder decodeObjectForKey:HSHeaderModelStr];
        _channelCodeStr       = [aDecoder decodeObjectForKey:HSChannelCodeStr];
        _userIdStr           = [aDecoder decodeObjectForKey:HSUserIdStr];
        _portraintUrl         = [aDecoder decodeObjectForKey:HSPortraintUrlStr];
        _portraintImg         = [aDecoder decodeObjectForKey:HSPortraintImg];
        _sixStr              = [aDecoder decodeObjectForKey:HSSixStr];
        _birthdayStr          = [aDecoder decodeObjectForKey:HSBirthdayStr];
         _operatorTimeStr      = [aDecoder decodeObjectForKey:JTOperatorTimeStr];
    }
    return self;
}
@end
