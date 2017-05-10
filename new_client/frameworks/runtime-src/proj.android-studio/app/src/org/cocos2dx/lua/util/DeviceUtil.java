package org.cocos2dx.lua.util;

import android.telephony.SignalStrength;
import android.util.Log;

import org.cocos2dx.lua.util.SignalStrengthUtil;

/**
 * Created by Shusi on 2017/3/3.
 */

public class DeviceUtil {
    protected static int batteryLevel = 0;
    protected static int batteryStatus = 0;
    private static int mobileSignalLevel;

    public static int getBatteryLevel() {
        return batteryLevel;
    }

    public static void setBatteryLevel(int level) {
        batteryLevel = level;
//        Log.i("DeviceUtil", "battery level:" + batteryLevel);
    }

    public static int getBatteryStatus() {
        return batteryStatus;
    }

    public static void setBatteryStatus(int status) {
        batteryStatus = status;
    }

    public static int getMobileSignalLevel() {
        return mobileSignalLevel;
    }

    public static void setMobileSignalLevel(SignalStrength signalStrength) {
        mobileSignalLevel = new SignalStrengthUtil(signalStrength).getLevel();
//        Log.d("DeviceUtil", "mobileSignalLevel:" + mobileSignalLevel);
    }
}
