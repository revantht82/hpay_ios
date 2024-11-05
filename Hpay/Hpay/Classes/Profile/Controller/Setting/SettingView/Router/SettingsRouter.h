//
//  SettingsRouter.h
//  Hpay
//
//  Created by Olgu Sirman on 22/01/2021.
//  Copyright © 2021 Himalaya. All rights reserved.
//

#import "HPProfileBaseRouter.h"
#import "FetchUserConfigAndInfoUseCase.h"

@protocol SettingsRouterInterface <HPProfileBaseRouterInterface>

- (void)pushToAgreementPrivacyForEULA;
- (void)pushToAgreementPrivacyDataPolicy;
- (void)pushToSupport;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SettingsRouter : HPProfileBaseRouter <SettingsRouterInterface>
@property (nonatomic) FetchUserConfigAndInfoUseCase *fetchUserConfigAndInfoUseCase;

@end

NS_ASSUME_NONNULL_END
