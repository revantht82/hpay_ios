#ifndef AppColor_h
#define AppColor_h


// Convert HEX to UIColor
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB6A(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.6]
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorMakeWithHex(hex) [UIColor colorWithHexString:hex]

// Get RGB color
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b) RGBA(r,g,b,1.0f)
#define RandColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define kCranberryColor UIColorFromRGB(0x111432)
#define kAccentColor UIColorFromRGB(0xECF1F4)
#define kDarkNightColor UIColorFromRGB(0x111432)
#define kDustyColor UIColorFromRGB(0x8e8e93)
#define kDustyColor25 UIColorFromRGBA(0x8e8e93, 0.25)
#define kCloudColor UIColorFromRGB(0xF9FAFC)
#define kMarigoldColor UIColorFromRGB(0xffcc00)
#define kSurfaceColor UIColorFromRGB(0xffffff)
#define kUnreadDotColor UIColorFromRGB(0xfb7292)
#define kBlackColor UIColorFromRGB(0x303133)

// almost the same
#define kBackgroundLightGray3 UIColorFromRGB(0xF2F6FC) // Little bit lighter - two usage - used also as cellBackgrounds

#endif /* AppColor_h */
