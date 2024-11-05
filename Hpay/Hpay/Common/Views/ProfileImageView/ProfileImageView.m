#import "ProfileImageView.h"

@interface ProfileImageView ()

// MARK: - Properties

@property (strong, nonatomic) UIView *viewContainer;
@property (strong, nonatomic) UILabel *labelInitials;
@property (strong, nonatomic) UIImageView *avatarImage;

@end


@implementation ProfileImageView

// MARK: - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

// MARK: - UI Elements

- (void)createViewContainer {
    UIView *container = [UIView new];
    container.borderWidth = 1.5f;
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = self.bounds.size.height / 2; // Perfect circle.
    container.layer.masksToBounds = YES;
    container.borderColor = kMarigoldColor;
    _viewContainer = container;
}

- (void)createInitialsLabel {
    UILabel *label = [UILabel new];
    label.textColor = [UIColor colorNamed:@"dark_night"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.75;
    label.adjustsFontSizeToFitWidth = YES;
    _labelInitials = label;
}

-(void)createProfileAvatar{
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:[UIImage imageNamed:@"profile_account_avatar"]];
    _avatarImage = imageView;
    _avatarImage.frame = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
    _avatarImage.layer.cornerRadius = self.bounds.size.height / 2;
}

// MARK: - Helpers

- (void)sharedInit {
    [self createViewContainer];
    [self createInitialsLabel];
    [self createProfileAvatar];
    [self.viewContainer addSubview:self.labelInitials];
    [self.viewContainer addSubview:self.avatarImage];
    [self addSubview:self.viewContainer];
    [self.labelInitials setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.labelInitials mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.viewContainer);
    }];
    [self.viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self setupWithUserName:@"" lastName:@""];
}

// MARK: - Internal

- (void)setupWithUserName:(NSString*)name lastName:(NSString*)lastName {
    NSString *initials = [NSString stringWithFormat:@"%@%@",
                          [name length] >= 1 ? [name substringToIndex:1] : @"",
                          [lastName length] >= 1 ? [lastName substringToIndex:1] : @""];
    
    float spacing = 0.5f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:initials];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [initials length])];
    if (attributedString.length > 0) {
        self.labelInitials.attributedText = attributedString;
        self.avatarImage.hidden = YES;
    } else {
        self.avatarImage.hidden = NO;
    }
}

@end
