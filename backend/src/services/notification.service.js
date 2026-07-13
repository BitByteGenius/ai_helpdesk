import Notification from "../models/notification.model.js";
import { sendToUser } from "../../socket/socket.js";

/**
 * Create Notification
 */
export const createNotification = async ({
  user,
  title,
  message,
  type = "system",
  referenceId = null,
  referenceModel = "",
}) => {
  try {
   const notification = await Notification.create({
    user,
    title,
    message,
    type,
    referenceId,
    referenceModel,
});

    sendToUser(user, "notification:new", notification);
    sendToUser(user, "notification", notification);


    return notification;
  } catch (error) {
    console.error("Create Notification Error:", error);
    return null;
  }
};

/**
 * Mark One Notification Read
 */
export const markAsRead = async (id) => {
  return await Notification.findByIdAndUpdate(
    id,
    {
      isRead: true,
    },
    {
      new: true,
    }
  );
};

/**
 * Mark All Notifications Read
 */
export const markAllAsRead = async (userId) => {
  return await Notification.updateMany(
    {
      user: userId,
      isRead: false,
    },
    {
      isRead: true,
    }
  );
};

/**
 * Delete Notification
 */
export const deleteNotification = async (id) => {
  return await Notification.findByIdAndDelete(id);
};
