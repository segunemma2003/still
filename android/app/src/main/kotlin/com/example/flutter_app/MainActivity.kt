package com.example.flutter_app

import android.app.Activity
import android.app.KeyguardManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import android.os.PowerManager
import android.view.WindowManager
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "stillur_app/lifecycle"
    private val NOTIFICATION_CHANNEL_ID = "stillur_call_notifications"
    private val NOTIFICATION_ID = 12345
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Create notification channel for call notifications
        createNotificationChannel()
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "bringToForeground" -> {
                    bringAppToForeground()
                    result.success(true)
                }
                "registerForBackgroundCallNotifications" -> {
                    registerForBackgroundNotifications()
                    result.success(true)
                }
                "unregisterFromBackgroundCallNotifications" -> {
                    unregisterFromBackgroundNotifications()
                    result.success(true)
                }
                "showForegroundCallNotification" -> {
                    val callerName = call.argument<String>("callerName") ?: "Unknown"
                    val callData = call.argument<Map<String, Any>>("callData") ?: emptyMap()
                    showForegroundCallNotification(callerName, callData)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Call Notifications"
            val descriptionText = "High priority notifications for incoming calls"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, name, importance).apply {
                description = descriptionText
                enableVibration(true)
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE), null)
                setBypassDnd(true)
                lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
            }
            
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun bringAppToForeground() {
        try {
            // Wake up the screen if it's off
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!powerManager.isInteractive) {
                val wakeLock = powerManager.newWakeLock(
                    PowerManager.SCREEN_BRIGHT_WAKE_LOCK or 
                    PowerManager.ACQUIRE_CAUSES_WAKEUP or 
                    PowerManager.ON_AFTER_RELEASE,
                    "StillurApp::CallWakeUp"
                )
                wakeLock.acquire(3000) // 3 seconds
            }
            
            // Dismiss keyguard if device is locked
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setShowWhenLocked(true)
                setTurnScreenOn(true)
                
                val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
                keyguardManager.requestDismissKeyguard(this, null)
            } else {
                window.addFlags(
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                )
            }
            
            // Bring activity to front
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or 
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT
            }
            startActivity(intent)
            
            // Notify Flutter that app was brought to foreground
            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL)
                .invokeMethod("onAppBroughtToForeground", null)
                
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun registerForBackgroundNotifications() {
        // This method can be used to register with FCM or other push notification services
        // when the app goes to background to receive call notifications
        println("Registered for background call notifications")
    }
    
    private fun unregisterFromBackgroundNotifications() {
        // This method can be used to unregister from push notifications
        // when the app comes to foreground
        println("Unregistered from background call notifications")
    }
    
    private fun showForegroundCallNotification(callerName: String, callData: Map<String, Any>) {
        try {
            // Create intent to open the app when notification is tapped
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("action", "incoming_call")
                putExtra("caller_name", callerName)
            }
            
            val pendingIntent = PendingIntent.getActivity(
                this, 0, intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Create full-screen intent for when device is locked
            val fullScreenIntent = PendingIntent.getActivity(
                this, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Build the notification
            val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_call)
                .setContentTitle("Incoming Call")
                .setContentText("Call from $callerName")
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_CALL)
                .setFullScreenIntent(fullScreenIntent, true)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setOngoing(true)
                .setVibrate(longArrayOf(0, 1000, 500, 1000))
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE))
                .addAction(android.R.drawable.ic_menu_call, "Answer", pendingIntent)
                .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Decline", pendingIntent)
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID, builder.build())
            
            // Also bring app to foreground immediately
            bringAppToForeground()
            
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}