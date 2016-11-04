//
//  Universe.m
//  skytime
//


#import "Universe.h"

@implementation Universe


int gYear, gMonth, gDay, gHour, gMinute;
double gSeconds;
double JD;
double LST, MST;
double gLatitude = 54.5, gLongitude = -5.5;
double gDaylight;
double gTimezone;
double UT;

int gDayOfWeek;

BOOL is24HourFormat = FALSE;


static inline double rev(double angle)		{return angle-floor(angle/360.0)*360.0;}

+(NSString *) getAMPM
{
    if (is24HourFormat)
    {
        
        return @"";
    }
    else
    {
        if (gHour>=12)
        {
            if (gHour==12)
                return @"PM";
            else
                return @"PM";
        }
        else
            return @"AM";
    }
    
    
    
}


+(NSString *)formatTime :(int) hour : (int)minute : (double) seconds
{
    if (is24HourFormat)
    {
        
        return [NSString stringWithFormat:@"%02d:%02d:%02.0f",hour, minute, gSeconds];
    }
    else
    {
        if (hour>=12)
        {
            if (hour==12)
                return [NSString stringWithFormat:@"%d:%02d:%02.0f",hour, minute, gSeconds];
            else
                return [NSString stringWithFormat:@"%d:%02d:%02.0f",hour-12, minute, gSeconds];
        }
        else
            return [NSString stringWithFormat:@"%d:%02d:%02.0f",hour, minute, gSeconds];
    }
}

+(void) Split: (double) number :  (int *)deg :  (int *)min :  (int *)sec
{
    // Helper routine to convert number into DMS
    
    short int ng;
    double d,m,s;
    
    
    if (number<0)
    {
        number=-number;
        ng=-1;
    }
    
    else
        ng=1;
    
    modf(number,&d);
    modf((number-d)*60,&m);
    s=3600*(number-(d+(m/60)));
    
    int dd = (int)(d*ng);
    int mm = (int) m;
    int ss = (int)s;
    
    *deg = dd;
    *min = mm;
    *sec = ss;
    
}


+(NSString *)getTimeString: (double) t
{
    if (t<=0) return @"n/a";
    
    int hour, minute, second;
    
    [self Split:t :&hour :&minute :&second];
    
    return [self formatTime : hour:minute:second];
}


+(NSString *)formatSideralTime: (double) time
{
    BOOL temp2d = is24HourFormat;
    
    is24HourFormat = TRUE;
    
    NSString *tempString = [NSString stringWithFormat:@"%@",[self getTimeString: time]];
    
    is24HourFormat = temp2d;
    
    return tempString;
    
}


+(NSString *)formatPosition: (double)pos
{
    int deg,min;
    deg= (pos<0) ? (int)floor(-pos) : (int)floor(pos);
    min = 60 *( fabs(pos) - (double)deg);
    if (pos<0)
        return [NSString stringWithFormat:@"-%dº %02d'",deg,min];
    else
        return [NSString stringWithFormat:@"%dº %02d'",deg,min];
}


+(void) setLocation: (double) lat : (double) lon
{
    gLatitude = lat;
    gLongitude = lon;
    
    
}

+(void) set24Hour: (BOOL) is24Hour
{
    is24HourFormat = is24Hour;
    
}

+(double) calculateJulian
{
    
    
    
    double tt = (double)gHour - (double)gTimezone; // !!
    
    double y = gYear;
    double m = gMonth;
    double d = gDay;
    double t = (double)tt + (double)(gMinute)/60.0 + (double) (gSeconds)/3600.0;;
    
    UT = t;
    
    if (m <= 2) {
        y = y - 1;
        m = m + 12;
    }
    
    double a = floor(y/100.0);
    double b = 2 - a + floor(a/4.0);
    d += t/24.0;
    return JD = floor(365.25*(y+4716.0))+floor(30.6001*(m+1))+d+b-1524.5;
    
    
}

+(double) calculateMST
{
    
    double jd = JD - 2451545.0;
    double jt = (JD-2451545.0) / 36525.0;
    
    double  mst = 280.46061837 + 360.98564736629*jd + 0.000387933*jt*jt - jt*jt*jt/38710000.0  ;
    mst = fmod(mst, 360);
    if (mst<0) mst+=360;
    
    MST = (mst);
    return mst;
    
}


+(double) calculateLST
{
    LST = (rev(MST + gLongitude)/15.0);
    return LST;
}




+(void) calculateCurrentDate
{
    
    
    NSDate *currentTime = [NSDate date]; // This is an autorelease object
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitWeekday ) fromDate:currentTime];
    NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:currentTime];
    
    double timezoneOffset = [[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
    
    gYear  = (int) [dateComponents year];
    gDay   = (int) [dateComponents day];
    gMonth  = (int) [dateComponents month];
    
    gHour = (int) [timeComponents hour];
    
    gMinute = (int) [timeComponents minute];
    gSeconds = [timeComponents second];
    
    gTimezone = timezoneOffset ;
    
    gDaylight = 0;
    
    gDayOfWeek = (int)[dateComponents weekday] - 1;
    
    
    
}

+(void) calculateTime
{
    [self calculateCurrentDate];
    [self calculateJulian];
    [self calculateMST];
    [self calculateLST];
    
    
    
}

+(NSString *) getGMTDelta
{
    
    if (gTimezone == 0)
        return  [NSString stringWithFormat:@"None"];
    
    else
        
    {
        
        if (fabs(gTimezone) == 1)
            return  [NSString stringWithFormat:@"%.0f Hour",gTimezone];
        else
            return  [NSString stringWithFormat:@"%.1f Hours",gTimezone];
        
    }
}

+(NSString *) getJulian
{
    
    return [NSString stringWithFormat:@"%.5f",JD];
}


+(NSString *) getModifiedJulian
{
    return [NSString stringWithFormat:@"%.5f",(JD-2400000.5)];
    
}

+(NSString *) getTime
{
    return [NSString stringWithFormat:@"%@", [self formatTime: gHour : gMinute :gSeconds]];
    
}


+(NSString *)getHour
{
    if (is24HourFormat)
    {
        
        return [NSString stringWithFormat:@"%02d:",gHour];
    }
    else
    {
        if (gHour>=12)
        {
            if (gHour==12)
                return [NSString stringWithFormat:@"%d:",gHour];
            else
                return [NSString stringWithFormat:@"%d:",gHour-12];
        }
        else
            return [NSString stringWithFormat:@"%d:",gHour];
    }
    
    
    
    
    return [NSString stringWithFormat:@"%2d:",gHour];
}


+(int) getHourD
{
    if (is24HourFormat)
    {
        
        return gHour;
    }
    else
    {
        if (gHour>=12)
        {
            if (gHour==12)
                return gHour;
            else
                return gHour-12;
        }
        else
            return gHour;
    }
    
    
    return gHour;
}


+(int) getMinuteD
{
    return gMinute;
}

+(int) getSecondD
{
    return gSeconds;
}

+(NSString *)getMinute
{
    return [NSString stringWithFormat:@"%02d",gMinute];
}

+(NSString *)getSecond
{
    return [NSString stringWithFormat:@"%02.f",gSeconds];
}



+(NSString *) getDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSDate *date = [NSDate date];
    
    return [dateFormatter stringFromDate:date];
    
}


+(NSString *) getLST
{
    return [NSString stringWithFormat:@"%@",[self formatSideralTime:LST]];
}



+(NSString *) getUT
{
    
    if (UT > 24) UT -= 24;
    if (UT < 0) UT += 24;
    
    return [NSString stringWithFormat:@"%@",[self formatSideralTime:UT]];
}

+(NSString *) getLocation
{
    
    return [NSString stringWithFormat:@"Latitude: %@\tLongitude: %@",[self formatPosition:gLatitude], [self formatPosition: gLongitude]];
}


@end
