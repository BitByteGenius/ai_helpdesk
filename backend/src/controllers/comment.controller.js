import mongoose from "mongoose";
import Ticket from "../models/ticket.model.js";
import { createNotification } from "../services/notification.service.js";
import {
  broadcastToAdmins,
  sendToTicketRoom,
} from "../../socket/socket.js";

import {
  createCommentService,
  getCommentsService,
  findCommentService,
  updateCommentService,
  deleteCommentService,
} from "../services/comment.service.js";



/**
 * Create Comment
 * POST /api/tickets/:id/comments
 */
export const createComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { message, attachments = [] } = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid Ticket ID",
      });
    }

    const ticket = await Ticket.findById(id);

    if (!ticket || ticket.isDeleted) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    const comment = await createCommentService({
      ticket: id,
      author: req.user.userId,
      message,
      attachments,
    });

    // Notify ticket owner if someone else commented
const notificationMessage =
  req.user.role === "admin"
    ? "An administrator replied to your ticket."
    : "A user replied to the ticket.";

    if (ticket.createdBy.toString() !== req.user.userId) {
      await createNotification({
        user: ticket.createdBy,
        title: "New Comment",
        message: notificationMessage,
    type: "comment",
    referenceId: ticket._id,
        referenceModel: "Ticket",
      });
    }

    sendToTicketRoom(id, "comment:update", {
      action: "created",
      comment,
    });
    sendToTicketRoom(id, "comment:new", comment);
    broadcastToAdmins("dashboard:update", {
      type: "comment",
      action: "created",
      ticketId: id,
      commentId: comment._id,
    });

    return res.status(201).json({
      success: true,
      message: "Comment added successfully",
      data: comment,
    });
  } catch (error) {
    console.error("CREATE COMMENT ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get Ticket Comments
 * GET /api/tickets/:id/comments
 */
export const getComments = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid Ticket ID",
      });
    }

    const comments = await getCommentsService(id);

    return res.status(200).json({
      success: true,
      count: comments.length,
      data: comments,
    });
  } catch (error) {
    console.error("GET COMMENTS ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update Comment
 * PUT /api/comments/:id
 */
export const updateComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { message } = req.body;

    const comment = await findCommentService(id);

    if (!comment) {
      return res.status(404).json({
        success: false,
        message: "Comment not found",
      });
    }

    // Only author or admin
    if (
      req.user.role !== "admin" &&
      comment.author._id.toString() !== req.user.userId
    ) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
      });
    }

    const updatedComment = await updateCommentService(
      comment,
      message
    );

    sendToTicketRoom(comment.ticket._id.toString(), "comment:update", {
      action: "updated",
      comment: updatedComment,
    });
    broadcastToAdmins("dashboard:update", {
      type: "comment",
      action: "updated",
      ticketId: comment.ticket._id.toString(),
      commentId: updatedComment._id,
    });

    return res.status(200).json({
      success: true,
      message: "Comment updated successfully",
      data: updatedComment,
    });
  } catch (error) {
    console.error("UPDATE COMMENT ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Delete Comment
 * DELETE /api/comments/:id
 */
export const deleteComment = async (req, res) => {
  try {
    const { id } = req.params;

    const comment = await findCommentService(id);

    if (!comment) {
      return res.status(404).json({
        success: false,
        message: "Comment not found",
      });
    }

    // Only author or admin
    if (
      req.user.role !== "admin" &&
      comment.author._id.toString() !== req.user.userId
    ) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
      });
    }

    await deleteCommentService(comment);

    sendToTicketRoom(comment.ticket._id.toString(), "comment:update", {
      action: "deleted",
      commentId: comment._id,
    });
    broadcastToAdmins("dashboard:update", {
      type: "comment",
      action: "deleted",
      ticketId: comment.ticket._id.toString(),
      commentId: comment._id,
    });

    return res.status(200).json({
      success: true,
      message: "Comment deleted successfully",
    });
  } catch (error) {
    console.error("DELETE COMMENT ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
