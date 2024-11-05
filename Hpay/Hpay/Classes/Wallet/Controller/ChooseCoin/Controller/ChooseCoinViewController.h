//
//  ChooseCoinViewController.h
//  FiiiPay
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018 Himalaya. All rights reserved.
//

#import "FPViewController.h"
#import "PreTransferModel.h"

@class FBCoin;

@interface ChooseCoinViewController : FPViewController
- (void)configCoinActionType:(CoinActionType)actionType;
- (void)configCoinActionType:(CoinActionType)actionType withWalletList:(NSArray *)coinArr andCurIndex:(NSInteger)idx didSelectBlock:(void (^)(FBCoin *coin, NSInteger idx))selectBlock;
- (void)configCoinActionType:(CoinActionType)actionType withWalletList:(NSArray *)coinArr andCurIndex:(NSInteger)idx andFC:(NSString *)fCurrence didSelectBlock:(void (^)(FBCoin *coin, NSInteger idx))selectBlock;

@property(strong, nonatomic) NSString *userHash;
@property(nonatomic, strong) PreTransferModel *transferModel;
@property(nonatomic, copy) NSDictionary *infoDict;
@property(nonatomic, copy) NSArray *infoArray;

@end
