//
//  AppFontSize.h
//  HomeHealthNew
//
//  Created by cheungBoy on 2017/6/24.
//
//

#ifndef AppFontSize_h
#define AppFontSize_h

#pragma mark - Primary
#pragma mark Primary - Weight

#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]
#define UIFontLightMake(size) [UIFont systemFontOfSize:size weight:UIFontWeightLight]

#define kFontMediumWeight(fontSize) [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium]
#define kFontSemiboldWeight(fontSize) [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold]

#pragma mark - Secondary
#define kFontSecondaryRegular(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]
#define kFontSecondarySemibold(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]
#define kFontSecondaryMedium(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]



#endif /* AppFontSize_h */
