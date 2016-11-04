//
//  Universe.h
//  skytime
//


// Time Calculations..
#import <Foundation/Foundation.h>

@interface Universe : NSObject


+(void) calculateTime;

+(NSString *) getJulian;
+(NSString *) getModifiedJulian;
+(NSString *) getTime;
+(NSString *) getDate;
+(NSString *) getLST;
+(NSString *) getUT;
+(NSString *) getLocation;
+(NSString *) getAMPM;
+(NSString *) getGMTDelta;
+(NSString *)getHour;
+(NSString *)getMinute;
+(NSString *)getSecond;

+(int) getHourD;
+(int) getMinuteD;
+(int) getSecondD;

+(void) setLocation: (double) lat : (double) lon;
+(void) set24Hour: (BOOL) is24Hour;

@end
