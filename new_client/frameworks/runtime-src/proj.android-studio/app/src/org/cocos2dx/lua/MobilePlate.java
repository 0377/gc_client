package org.cocos2dx.lua;

import java.security.MessageDigest;
import java.util.UUID;

import org.cocos2dx.lua.util.DeviceUtil;
import org.json.JSONArray;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.net.Uri;
import android.content.Intent;
import android.content.ComponentName;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.Display;
import java.util.regex.Pattern;
import java.util.regex.*;
public class MobilePlate {
	public static TelephonyManager mTelManager = null;
	public static Activity mActivity = null;
	public static Handler mHandler = null;
	
	public static Boolean isLooper = false;
	
	public static void setActivity(Activity activity){
		mActivity = activity;
		mTelManager = (TelephonyManager) mActivity.getSystemService(Context.TELEPHONY_SERVICE);
	}
	
	public static void setHandler(Handler handler)
	{
		mHandler = handler;
	}
	public static String getBundleName()
	{
		PackageManager manager = mActivity.getPackageManager();
		String packageName = null;
		try
		{
			PackageInfo info = manager.getPackageInfo(mActivity.getPackageName(), 0);
			packageName = info.packageName;  //包名
//			int versionCode = info.versionCode;  //版本号
//			String versionName = info.versionName;   //版本名
		}
		catch (NameNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return packageName;
	}
	public static String getMd5(String plainText)
	{
        try {  
            MessageDigest md = MessageDigest.getInstance("MD5");  
            md.update(plainText.getBytes());  
            byte b[] = md.digest();  
  
            int i;  
  
            StringBuffer buf = new StringBuffer("");  
            for (int offset = 0; offset < b.length; offset++) {  
                i = b[offset];  
                if (i < 0)  
                    i += 256;  
                if (i < 16)  
                    buf.append("0");  
                buf.append(Integer.toHexString(i));  
            }   
            return buf.toString().substring(8, 24);  
        } catch (Exception e) {  
            e.printStackTrace();  
            return null;
        }  
	}
//
//	public static String getGuestId()
//	{
//		String s = UUID.randomUUID().toString();
//        return "Guest"+s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24);
//	}
	public static boolean checkIsChineseText(String str)
	{
		Pattern p_str = Pattern.compile("[\\u4e00-\\u9fa5]+");
		Matcher m = p_str.matcher(str);
		boolean ret = false;
		if(m.find()&&m.group(0).equals(str)){
			ret = true;
		}
		else
		{
			ret = false;
		}
		return ret;
	}

	public static boolean checkTextType(String str,String str1)
	{
		Pattern p_str = Pattern.compile(str1);
		Matcher m = p_str.matcher(str);
		boolean ret = false;
		if(m.find()&&m.group(0).equals(str)){
			ret = true;
		}
		else
		{
			ret = false;
		}
		return ret;
	}

	public static String getMobileType()
	{
		return android.os.Build.MODEL;
	}

	public static String  getDeviceId()
	{
		return mTelManager.getDeviceId();
	}

	public static String getMacAddr() {
		WifiManager wifi = (WifiManager) mActivity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
		WifiInfo info = wifi.getConnectionInfo();
		
		if (info != null){
			return info.getMacAddress();
		}
		
		return "00-00-00-00";
	}
	
	//复制到剪切板
	public static void copyStrToShearPlate( String str)
	{	
		System.out.println( str);
		//Looper lop =  Looper.myLooper();
		//lop.prepare();
		if ( isLooper == false)
		{
			Looper.prepare();
			isLooper = true;
		}
		ClipboardManager cmb = (ClipboardManager)mActivity.getSystemService(Context.CLIPBOARD_SERVICE);
		cmb.setPrimaryClip(ClipData.newPlainText(null, str));
		//Looper.loop();
		//lop.quit();
	}

	@SuppressLint("DefaultLocale") 
	public static String getScreenRes() {
		Display display = mActivity.getWindowManager().getDefaultDisplay();
		DisplayMetrics displayMetrics = new DisplayMetrics();
		display.getMetrics(displayMetrics);
		float width = displayMetrics.widthPixels;
		float height = displayMetrics.heightPixels;
		
		return width + "X" + height;
	}

	public static String getOsVersion() {
		return android.os.Build.VERSION.RELEASE;
	}
	
	public static String getChannelName(){
		ApplicationInfo appInfo;
		String channleName = "";
		try {
			appInfo = mActivity.getPackageManager()
			        .getApplicationInfo(mActivity.getPackageName(),
			PackageManager.GET_META_DATA);
			channleName=appInfo.metaData.getString("channleId");
		} catch (NameNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return channleName;
	}
	
	public static String getVersionName(){
		String appVersion = "";
		PackageManager manager = mActivity.getPackageManager();   
		try {
			PackageInfo info = manager.getPackageInfo(mActivity.getPackageName(), 0);  
			appVersion = info.versionName;   //版本名      
		} catch (NameNotFoundException e) {   
			e.printStackTrace();  
		}
		return appVersion;
	}

	public static void callQQChat(String qqNumber) {
		Message msg = new Message();
		msg.what = GameBase.CALL_QQ_CHAT;
		msg.obj = qqNumber;
		mHandler.sendMessage(msg);
	}

	//判断是否安装支付宝
	public static String checkAliPayInstalled() {
		Uri uri = Uri.parse("alipays://platformapi/startApp");
		Intent intent = new Intent(Intent.ACTION_VIEW, uri);
		ComponentName componentName = intent.resolveActivity(mActivity.getPackageManager());
		 if(componentName != null)
		 {
			 return "true";
		 }else
		 {
			 return "false";
		 }
	}

	public static void showWebView(String url,String title,int callback,String args) {
		ShowUrlInfo urlInfo = new ShowUrlInfo();
		urlInfo.urlstr = url;
		urlInfo.title = title;
		urlInfo.callback = callback;
		urlInfo.args = args;

		Message msg = new Message();
		msg.what = GameBase.SHOW_WEBVIEW;
		msg.obj = urlInfo;
		mHandler.sendMessage(msg);
	}

	public static void openBrowser(String url) {
		Message msg = new Message();
		msg.what = GameBase.OPEN_BROWSER;
		msg.obj = url;
		mHandler.sendMessage(msg);
	}

	/**
	 * 获取电量
	 * value:0-100
	 * @return
     */
	public static int getBatteryLevel(){
		return DeviceUtil.getBatteryLevel();
	}

	/**
	 * 获取电池状态
	 * 2:充电中；not 2:未充电
	 */
	public static int getBatteryStatus() {
		return DeviceUtil.getBatteryStatus();
	}

	/**
	 * 获取网络信号
	 * value:0-4
	 */
	public static int getMobileSignalLevel() {
		return DeviceUtil.getMobileSignalLevel();
	}

	/**
	 * 获取wifi信号
	 * value:0-4
	 * @return
     */
	public static int getWifiSignalLevel() {
		if (mActivity == null) {
			return 0;
		}

		WifiManager wifiManager = ((WifiManager) mActivity.getApplicationContext().getSystemService(Context.WIFI_SERVICE));
		int rssi = 0;
		if (wifiManager != null && wifiManager.getWifiState() == WifiManager.WIFI_STATE_ENABLED) {
			rssi = wifiManager.getConnectionInfo().getRssi();
		}
		return WifiManager.calculateSignalLevel(rssi, 5);
	}

	/**
	 * 获取上网类型
	 * type: 0:none; 1:wifi; 2:mobil
	 */
	public static int getConnectivityType() {
		if (mActivity == null) {
			return 0;
		}

		ConnectivityManager connManager = (ConnectivityManager) mActivity
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		// 获取代表联网状态的NetWorkInfo对象
		NetworkInfo networkInfo = connManager.getActiveNetworkInfo();

		int connectType = 0;
		// 获取当前的网络类型
		if (networkInfo != null && networkInfo.isConnected()) {
			connectType = networkInfo.getType();
		}

		switch(connectType) {
			case ConnectivityManager.TYPE_WIFI:
				connectType = 1;
				break;
			case ConnectivityManager.TYPE_MOBILE:
				connectType = 2;
				break;
			default:
				connectType = 0;
				break;
		}

		return  connectType;
	}
}
