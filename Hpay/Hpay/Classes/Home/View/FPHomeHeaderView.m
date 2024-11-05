//
//  FPHomeHeaderView.m
//  HomeDemo
//
//  Created by Singer on 2019/7/2.
//  Copyright © 2019 Himalaya. All rights reserved.
//

#import "FPHomeHeaderView.h"
#import "UserConfigResponse.h"
#import "HimalayaAuthKeychainManager.h"

@interface FPHomeHeaderView ()
@property(weak, nonatomic) IBOutlet UIView *topMenuBgView;
@property(weak, nonatomic) IBOutlet UIView *botttomMenuBgView;
@property(weak, nonatomic) IBOutlet UIView *transferView;
@property(weak, nonatomic) IBOutlet UIView *requestView;
@property(weak, nonatomic) IBOutlet UIView *huazhuanView;
@property(weak, nonatomic) IBOutlet UIButton *buttonSend;
@property(weak, nonatomic) IBOutlet UIButton *buttonScan;
@property(weak, nonatomic) IBOutlet UIButton *buttonTransfer;
@property(weak, nonatomic) IBOutlet UIButton *buttonRequest;
@property(weak, nonatomic) IBOutlet UILabel *labelSend;
@property(weak, nonatomic) IBOutlet UILabel *labelScan;
@property(weak, nonatomic) IBOutlet UILabel *labelTransfer;
@property(weak, nonatomic) IBOutlet UILabel *labelRequest;
@property (weak, nonatomic) IBOutlet UIButton *buttonBell;
@property (weak, nonatomic) IBOutlet UILabel *labelRedDot;
@property (weak, nonatomic) IBOutlet UIView *selectEglishView;
@property (weak, nonatomic) IBOutlet UIView *bellView;
@property (weak, nonatomic) IBOutlet UIButton *langButton;
@property (weak, nonatomic) IBOutlet UIImageView *langIcon;
@property (weak, nonatomic) IBOutlet UILabel *secondLangLineLabel;

@end

@implementation FPHomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _buttonSend.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonScan.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonTransfer.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _buttonRequest.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentLanguage) name:@"languageChanged" object:nil];
    
    [self applyTheme];
    [self setCurrentLanguage];
}

-(void)setCurrentLanguage {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    
    //NSLog(@"%@", languages);
    
    NSString *languageName = @"English";
    CGRect frame = self.langIcon.frame;
    frame.origin.x = 72;
    self.langButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.langButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.secondLangLineLabel.hidden = YES;
    
    if ([languages isKindOfClass:[NSArray class]] && languages.count > 0 &&
        [[languages[0] lowercaseString] rangeOfString:@"zh-hans"].location != NSNotFound ){
        languageName = @"简体中文";
        self.langButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.langButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        frame.origin.x = 30;
        self.secondLangLineLabel.hidden = NO;
    }
    self.langIcon.frame = frame;
    [self.langButton setTitle:languageName forState:UIControlStateNormal];
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self applyTheme];
}

- (void)showAlert:(NSNumber *)show{
    if (show && [show intValue] > 0 && !self.buttonBell.hidden){
        self.labelRedDot.hidden = NO;
    }
    else {
        self.labelRedDot.hidden = YES;
    }
}

- (void)applyTheme{
    id<ThemeProtocol> theme = [self getCurrentTheme];
    self.buttonSend.backgroundColor = theme.dashboardItem;
    self.buttonScan.backgroundColor = theme.dashboardItem;
    self.buttonTransfer.backgroundColor = theme.dashboardItem;
    self.buttonRequest.backgroundColor = theme.dashboardItem;
    self.labelScan.textColor = theme.primaryOnBackground;
    self.labelSend.textColor = theme.primaryOnBackground;
    self.labelTransfer.textColor = theme.primaryOnBackground;
    self.labelRequest.textColor = theme.primaryOnBackground;
    self.buttonBell.tintColor = theme.primaryOnBackground;
    self.langIcon.tintColor = theme.primaryOnBackground;
    [self.langButton setTitleColor:theme.primaryOnBackground forState:UIControlStateNormal];
}

- (IBAction)bellAction {
    if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
        [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeBell];
    }
}

- (void)hideBellBtn:(BOOL)show{
    self.bellView.hidden = show;
    self.selectEglishView.hidden = !show;
}

- (IBAction)scanAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
        [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeScan];
    }
}

- (IBAction)transferAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
        [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeTransfer];
    }
}


- (IBAction)huazhuanClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
        [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeFiiiEX];
    }
}

- (UserConfigResponse *)userConfig{
    NSError *error;
    return [HimalayaAuthKeychainManager loadUserConfigToKeychain:&error];
}

- (IBAction)requestAction:(UIButton *)sender {
    
    UserConfigResponse *response = [self userConfig];
    
    if([response.userType isEqualToString:@"INDIVIDUAL"]){
        if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
            [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeRequestIndividual];
        }
        
    }
    else if([response.userType isEqualToString:@"MERCHANT"]){
        if ([self.delegate respondsToSelector:@selector(homeHeadViewClickWithType:)]) {
            [self.delegate homeHeadViewClickWithType:HomeHeadViewClickTypeRequest];
        }
    }
    
    
   
}
- (IBAction)langSelectPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLanguageChangeMenu" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
