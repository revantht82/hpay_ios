//
//  HPayUITestsLaunchTests.m
//  HPayUITests
//
//  Created by Alexander Alekseev on 05/09/2023.
//  Copyright © 2023 Himalaya. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HPayUITestsLaunchTests : XCTestCase

@end

@implementation HPayUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
