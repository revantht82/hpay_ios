#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HPAYBioAuth : NSObject

+ (HPAYBioAuth*)sharedInstance;

-(void)savePIN:(NSString*)PIN;
-(NSString *)getPIN;
-(void)deletePIN;

-(void) saveIsAlreadyAskedForBioAuth:(NSNumber*)value;
-(NSNumber*) getAlreadyAskedForBioAuth;
-(void) saveIsBioAuthOn:(NSNumber*)value;
-(NSNumber*) getBioAuthOn;
-(NSNumber*) getIsNeedToSavePIN;
-(void) saveIsNeedToSavePIN:(bool)value;
-(BOOL) getIsBioAuthAvailable;
-(void) saveIsBioAuthAvailable:(NSString*)value;
-(void) checkIsBioAvailable;
-(NSDictionary*)getBioAuthData;
-(BOOL) checkForSystemAlert;

@end
