package com.example.champion_car_wash_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.*

class UpcomingBookingWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            try {
                val views = RemoteViews(context.packageName, R.layout.booking_widget_layout)

                val data = HomeWidgetPlugin.getData(context)

                // Get booking details with defaults
                val service = data.getString("booking_service", null) ?: "Car Wash Service"
                val customer = data.getString("booking_customer", null) ?: "Customer Name"
                val date = data.getString("booking_date", null) ?: "Oct 24, 2025"
                val time = data.getString("booking_time", null) ?: "2:00 PM"
                val vehicle = data.getString("booking_vehicle", null) ?: "Vehicle Details"
                val status = data.getString("booking_status", null) ?: "ACTIVE"

                // Update all fields
                views.setTextViewText(R.id.widget_booking_service, service)
                views.setTextViewText(R.id.widget_booking_customer, customer)
                views.setTextViewText(R.id.widget_booking_date, date)
                views.setTextViewText(R.id.widget_booking_time, time)
                views.setTextViewText(R.id.widget_booking_vehicle, vehicle)
                views.setTextViewText(R.id.widget_booking_status_badge, status)

                // Set click intent to open app - entire widget is clickable
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("from_widget", true)
                    putExtra("widget_type", "booking")
                }
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    0, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                
                // Make entire widget clickable
                views.setOnClickPendingIntent(R.id.widget_booking_title, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                android.util.Log.e("BookingWidget", "Error updating widget: ${e.message}")
            }
        }
    }
}

class ServiceStatusWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            try {
                val views = RemoteViews(context.packageName, R.layout.status_widget_layout)

                val data = HomeWidgetPlugin.getData(context)
                
                // Get all status counts with safe defaults
                val openCount = try { data.getInt("open_service_count", 0) } catch (e: Exception) { 0 }
                val prebookingCount = try { data.getInt("prebooking_count", 0) } catch (e: Exception) { 0 }
                val inprogressCount = try { data.getInt("inprogress_service_count", 0) } catch (e: Exception) { 0 }
                val completedCount = try { data.getInt("completed_service_count", 0) } catch (e: Exception) { 0 }
                val totalCount = try { data.getInt("total_service_count", 0) } catch (e: Exception) { 0 }

                // Update all count displays
                views.setTextViewText(R.id.widget_total_count, totalCount.toString())
                views.setTextViewText(R.id.widget_open_count, openCount.toString())
                views.setTextViewText(R.id.widget_prebooking_count, prebookingCount.toString())
                views.setTextViewText(R.id.widget_inprogress_count, inprogressCount.toString())
                views.setTextViewText(R.id.widget_completed_count, completedCount.toString())

                // Update last updated time
                val currentTime = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())
                views.setTextViewText(R.id.widget_last_updated, "Updated $currentTime • Tap to refresh")

                // Set click intent to open app and refresh
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("refresh_widget", true)
                }
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    0, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_status_title, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                android.util.Log.e("StatusWidget", "Error updating widget: ${e.message}")
            }
        }
    }
}
