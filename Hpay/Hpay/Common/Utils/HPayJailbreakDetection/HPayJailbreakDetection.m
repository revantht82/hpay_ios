//
//  HPayJailbreakDetection.m
//  Hpay
//
//  Created by Olgu Sirman on 27/11/2020.
//  Copyright © 2020 Himalaya. All rights reserved.
//

#import "HPayJailbreakDetection.h"

@implementation HPayJailbreakDetection

+ (BOOL)isJailbroken {

#if !(TARGET_IPHONE_SIMULATOR)

    NSArray *pathsForCheckingDeviceJailbreakStatus = @[@"/Applications/Cydia.app",
                                           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                           @"/bin/bash",
                                           @"/usr/sbin/sshd",
                                           @"/etc/apt",
                                           @"/usr/bin/ssh",
                                           @"/private/var/lib/apt/",
                                           
                                           @"/usr/sbin/frida-server", // frida
                                           @"/etc/apt/sources.list.d/electra.list", // electra
                                           @"/etc/apt/sources.list.d/sileo.sources", // electra
                                           @"/.bootstrapped_electra", // electra
                                           @"/usr/lib/libjailbreak.dylib", // electra
                                           @"/jb/lzma", // electra
                                           @"/.cydia_no_stash", // unc0ver
                                           @"/.installed_unc0ver", // unc0ver
                                           @"/jb/offsets.plist", // unc0ver
                                           @"/usr/share/jailbreak/injectme.plist", // unc0ver
                                           @"/etc/apt/undecimus/undecimus.list", // unc0ver
                                           @"/var/lib/dpkg/info/mobilesubstrate.md5sums", // unc0ver
                                           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                           @"/jb/jailbreakd.plist", // unc0ver
                                           @"/jb/amfid_payload.dylib", // unc0ver
                                           @"/jb/libjailbreak.dylib", // unc0ver
                                           @"/usr/libexec/cydia/firmware.sh",
                                           @"/var/lib/cydia",
                                           @"/etc/apt",
                                           @"/private/var/lib/apt",
                                           @"/private/var/Users/",
                                           @"/var/log/apt",
                                           @"/Applications/Cydia.app",
                                           @"/private/var/stash",
                                           @"/private/var/lib/apt/",
                                           @"/private/var/lib/cydia",
                                           @"/private/var/cache/apt/",
                                           @"/private/var/log/syslog",
                                           @"/private/var/tmp/cydia.log",
                                           @"/Applications/Icy.app",
                                           @"/Applications/MxTube.app",
                                           @"/Applications/RockApp.app",
                                           @"/Applications/blackra1n.app",
                                           @"/Applications/SBSettings.app",
                                           @"/Applications/FakeCarrier.app",
                                           @"/Applications/WinterBoard.app",
                                           @"/Applications/IntelliScreen.app",
                                           @"/private/var/mobile/Library/SBSettings/Themes",
                                           @"/Library/MobileSubstrate/CydiaSubstrate.dylib",
                                           @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                                           @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                                           @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                                           @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
    ];
    
    FILE *file;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in pathsForCheckingDeviceJailbreakStatus) {

        const char *cPath = [path cStringUsingEncoding:NSASCIIStringEncoding];
        file = fopen(cPath, "r");
        if (file) {
            fclose(file);
            return YES;
        }
        
        if ([fileManager fileExistsAtPath:path])
            return YES;
    }
    
    // Omit logic below since they show warnings in the device log on iOS 9 devices.
    if (NSFoundationVersionNumber > 1144.17) // NSFoundationVersionNumber_iOS_8_4
        return NO;
    
    // Check if the app can access outside of its sandbox
    NSError *error = nil;
    NSString *string = @".";
    [string writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error)
        return YES;
    else
        [fileManager removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    
    // Check if the app can open a Cydia's URL scheme
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
        return YES;

#endif
    return NO;
}

@end
