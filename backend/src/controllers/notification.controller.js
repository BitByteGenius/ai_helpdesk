import Notification from "../models/notification.model.js";
import {
  markAsRead,
  markAllAsRead,
  deleteNotification,
} from "../services/notification.service.js";

/**
 * GET /api/notifications
 */
export const getNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({
      user: req.user.id,
    })
      .sort({ createdAt: -1 })
      .limit(100);

    res.status(200).json({
      success: true,
      data: notifications,
    });
  } catch (error) {
    console.error("Get Notifications Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch notifications",
    });
  }
};

/**
 * GET /api/notifications/unread-count
 */
export const getUnreadCount = async (req, res) => {
  try {
    const count = await Notification.countDocuments({
      user: req.user.id,
      isRead: false,
    });

    res.status(200).json({
      success: true,
      data: {
        unread: count,
      },
    });
  } catch (error) {
    console.error("Unread Count Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch unread count",
    });
  }
};

/**
 * PUT /api/notifications/:id/read
 */
export const readNotification = async (req, res) => {
  try {
    const notification = await Notification.findOne({
      _id: req.params.id,
      user: req.user.id,
    });

    if (!notification) {
      return res.status(404).json({
        success: false,
        message: "Notification not found",
      });
    }

    const updated = await markAsRead(notification._id);

    res.status(200).json({
      success: true,
      message: "Notification marked as read",
      data: updated,
    });
  } catch (error) {
    console.error("Read Notification Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to mark notification as read",
    });
  }
};

/**
 * PUT /api/notifications/read-all
 */
export const readAllNotifications = async (req, res) => {
  try {
    await markAllAsRead(req.user.id);

    res.status(200).json({
      success: true,
      message: "All notifications marked as read",
    });
  } catch (error) {
    console.error("Read All Notifications Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to mark notifications as read",
    });
  }
};

/**
 * DELETE /api/notifications/:id
 */
export const removeNotification = async (req, res) => {
  try {
    const notification = await Notification.findOne({
      _id: req.params.id,
      user: req.user.id,
    });

    if (!notification) {
      return res.status(404).json({
        success: false,
        message: "Notification not found",
      });
    }

    await deleteNotification(notification._id);

    res.status(200).json({
      success: true,
      message: "Notification deleted successfully",
    });
  } catch (error) {
    console.error("Delete Notification Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to delete notification",
    });
  }
};