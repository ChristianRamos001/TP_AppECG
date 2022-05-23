package com.smartheartmonitoring.pe.tappecg_ai

import android.os.Handler
import android.os.Looper
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.smartheartmonitoring.pe.tappecg_ai.services.NotificationActionService
import com.smartheartmonitoring.pe.tappecg_ai.services.NotificationRegistrationService

class PushNotificationsFirebaseMessagingService : FirebaseMessagingService() {
    
    companion object {
        var token : String? = null
        var notificationRegistrationService : NotificationRegistrationService? = null
        var notificationActionService : NotificationActionService? = null
    }

    override fun onNewToken(token: String) {
        PushNotificationsFirebaseMessagingService.token = token
        notificationRegistrationService?.refreshRegistration()
    }

    override fun onMessageReceived(message: RemoteMessage) {
        message.data.let {
            Handler(Looper.getMainLooper()).post {
                notificationActionService?.triggerAction(it.getOrDefault("action", null))
            }
        }
    }
}