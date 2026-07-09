import express from "express";

import protect from "../middleware/protect.js";

import {
  getNotifications,
  getUnreadCount,
  readNotification,
  readAllNotifications,
  removeNotification,
} from "../controllers/notification.controller.js";

const router = express.Router();

/**
 * Get all notifications
 */
router.get(
  "/",
  protect,
  getNotifications
);

/**
 * Get unread notification count
 */
router.get(
  "/unread-count",
  protect,
  getUnreadCount
);

/**
 * Mark all notifications as read
 */
router.put(
  "/read-all",
  protect,
  readAllNotifications
);

/**
 * Mark one notification as read
 */
router.put(
  "/:id/read",
  protect,
  readNotification
);

/**
 * Delete notification
 */
router.delete(
  "/:id",
  protect,
  removeNotification
);

export default router;