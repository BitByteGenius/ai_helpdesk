import mongoose from "mongoose";
import Ticket from "../models/ticket.model.js";
import User from "../models/user.model.js";
import Upload from "../models/upload.model.js";
import {
  assignTicketService,
  findTicketService,
  updateTicketStatusService,
} from "../services/assign.ticket.service.js";
import { createNotification } from "../services/notification.service.js";
import { createAudit } from "../services/audit.service.js";
import {
  broadcastToAdmins,
  sendToUser,
} from "../../socket/socket.js";

/**
 * Create Ticket
 * POST /api/tickets
 * Access: User/Admin
 */
export const createTicket = async (req, res) => {
  try {
    const {
      title,
      description,
      category,
      priority,
      summary,
      suggestedReply,
      duplicateTicket,
      attachments = [],
      aiConversationTranscript = "",
      aiConfidence = "Medium",
      aiSuggestedRootCause = "",
      aiTroubleshootingAttempted = "",
    } = req.body;

    const resolvedAttachments = [];
    if (Array.isArray(attachments) && attachments.length > 0) {
      const attachmentDocs = await Upload.find({
        _id: { $in: attachments.filter((attachment) => mongoose.Types.ObjectId.isValid(attachment)) },
        isDeleted: false,
      });

      const attachmentMap = new Map(
        attachmentDocs.map((attachment) => [attachment._id.toString(), attachment])
      );

      for (const attachment of attachments) {
        if (attachment && typeof attachment === "object") {
          resolvedAttachments.push(attachment);
          continue;
        }

        const matchedUpload = attachmentMap.get(String(attachment));
        if (matchedUpload) {
          resolvedAttachments.push({
            url: matchedUpload.url,
            fileName: matchedUpload.originalName,
            fileType: matchedUpload.fileType,
            fileSize: matchedUpload.fileSize,
          });
        }
      }
    }

    if (!title || !description) {
      return res.status(400).json({
        success: false,
        message: "Title and description are required",
      });
    }

    const ticket = await Ticket.create({
      title: title.trim(),
      description: description.trim(),

      category: category || "Other",
      priority: priority || "Medium",

      createdBy: req.user.userId,

      aiSummary: summary || "",
      aiSuggestedReply: suggestedReply || "",
      aiConversationTranscript,
      aiConfidence,
      aiSuggestedRootCause,
      aiTroubleshootingAttempted,

      duplicateTicket:
          typeof duplicateTicket === "string" &&
          mongoose.Types.ObjectId.isValid(duplicateTicket)
              ? duplicateTicket
              : null,

      attachments: resolvedAttachments,
    });

    // Notify all admins
    if (req.user.role === "user") {
      // Only notify admins when a user creates a ticket
      const admins = await User.find({ role: "admin", isDeleted: false });
      for (const admin of admins) {
        const notification = await createNotification({
          user: admin._id,
          title: "New Ticket",
          message: `${req.user.name || "A user"} created a new ticket: "${ticket.title}"`,
          type: "ticket",
          referenceId: ticket._id,
          referenceModel: "Ticket",
        });
        // Push real-time notification to admin via socket
        sendToUser(admin._id.toString(), "notification:new", notification);
      }
    }

    broadcastToAdmins("dashboard:update", {
      type: "ticket",
      action: "created",
      ticketId: ticket._id,
    });

    await createAudit({
      user: req.user.userId,
      action: "CREATE",
      entity: "TICKET",
      entityId: ticket._id,
      description: `Ticket created: "${ticket.title}"`,
      newData: { title: ticket.title, category: ticket.category, priority: ticket.priority },
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
    });

    const populatedTicket = await Ticket.findById(ticket._id)
      .populate("createdBy", "name email profileImage")
      .populate("assignedTo", "name email profileImage");

    return res.status(201).json({
      success: true,
      message: "Ticket created successfully",
      data: populatedTicket,
    });
  } catch (error) {
    console.error("CREATE TICKET ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get All Tickets
 * GET /api/tickets
 * Admin -> All Tickets
 * User -> Own Tickets
 */
export const getTickets = async (req, res) => {
  try {
    let {
      page = 1,
      limit = 10,
      search = "",
      status,
      priority,
      category,
      assignedTo,
    } = req.query;

    page = parseInt(page) || 1;
    limit = parseInt(limit) || 10;

    const filter = { isDeleted: false };

    // Normal users can only view their own tickets
    if (req.user.role === "user") {
      filter.createdBy = req.user.userId;
    }

    if (search) {
      filter.$or = [
        { title: { $regex: search, $options: "i" } },
        { description: { $regex: search, $options: "i" } },
      ];
    }

    if (status) filter.status = status;
    if (priority) filter.priority = priority;
    if (category) filter.category = category;
    if (assignedTo) filter.assignedTo = assignedTo;

    const total = await Ticket.countDocuments(filter);

    const tickets = await Ticket.find(filter)
      .populate("createdBy", "name email profileImage")
      .populate("assignedTo", "name email profileImage")
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(limit);

    return res.status(200).json({
      success: true,
      message: "Tickets fetched successfully",
      data: tickets,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("GET TICKETS ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get Ticket By ID
 * GET /api/tickets/:id
 */
export const getTicketById = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid ticket ID",
      });
    }

    const ticket = await Ticket.findOne({
      _id: id,
      isDeleted: false,
    })
      .populate("createdBy", "name email profileImage")
      .populate("assignedTo", "name email profileImage");

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    // Users can only access their own tickets
    if (
      req.user.role === "user" &&
      ticket.createdBy._id.toString() !== req.user.userId
    ) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
      });
    }

    return res.status(200).json({
      success: true,
      data: ticket,
    });
  } catch (error) {
    console.error("GET TICKET ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update Ticket
 * PUT /api/tickets/:id
 */
export const updateTicket = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid ticket ID",
      });
    }

    const ticket = await Ticket.findOne({ _id: id, isDeleted: false });

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    // User can only update own ticket while Open
    if (req.user.role === "user") {
      if (ticket.createdBy.toString() !== req.user.userId) {
        return res.status(403).json({
          success: false,
          message: "Access denied",
        });
      }
      if (ticket.status !== "Open") {
        return res.status(400).json({
          success: false,
          message: "Ticket can only be edited while it is Open",
        });
      }
    }

    const oldData = {
      title: ticket.title,
      description: ticket.description,
      category: ticket.category,
      priority: ticket.priority,
    };

    // Only allow safe fields to be updated
    const allowedFields = ["title", "description", "category", "priority", "summary", "suggestedReply"];
    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        ticket[field] = req.body[field];
      }
    }

    await ticket.save();

    await createAudit({
      user: req.user.userId,
      action: "UPDATE",
      entity: "TICKET",
      entityId: ticket._id,
      description: `Ticket updated: "${ticket.title}"`,
      oldData,
      newData: { title: ticket.title, category: ticket.category, priority: ticket.priority },
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
    });

    const populatedTicket = await Ticket.findById(ticket._id)
      .populate("createdBy", "name email profileImage")
      .populate("assignedTo", "name email profileImage");

    sendToUser(populatedTicket.createdBy.toString(), "ticket:update", {
      ticketId: populatedTicket._id,
      title: populatedTicket.title,
      status: populatedTicket.status,
      priority: populatedTicket.priority,
    });

    broadcastToAdmins("dashboard:update", {
      type: "ticket",
      action: "updated",
      ticketId: populatedTicket._id,
    });

    return res.status(200).json({
      success: true,
      message: "Ticket updated successfully",
      data: populatedTicket,
    });
  } catch (error) {
    console.error("UPDATE TICKET ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Delete Ticket (Soft Delete)
 * DELETE /api/tickets/:id
 */
export const deleteTicket = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid ticket ID",
      });
    }

    const ticket = await Ticket.findOne({ _id: id, isDeleted: false });

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    // Authorization check BEFORE deletion
    if (req.user.role === "user") {
      if (ticket.createdBy.toString() !== req.user.userId) {
        return res.status(403).json({
          success: false,
          message: "Access denied",
        });
      }
      if (ticket.status !== "Open") {
        return res.status(400).json({
          success: false,
          message: "Only Open tickets can be deleted",
        });
      }
    }

    ticket.isDeleted = true;
    ticket.deletedAt = new Date();
    await ticket.save();

    // Notify ticket owner (if admin deleted it)
    if (req.user.role === "admin") {
      const notification = await createNotification({
        user: ticket.createdBy,
        title: "Ticket Deleted",
        message: `Your ticket "${ticket.title}" has been removed by an administrator.`,
        type: "ticket",
        referenceId: ticket._id,
        referenceModel: "Ticket",
      });
      sendToUser(ticket.createdBy.toString(), "notification:new", notification);
    }

    await createAudit({
      user: req.user.userId,
      action: "DELETE",
      entity: "TICKET",
      entityId: ticket._id,
      description: `Ticket deleted: "${ticket.title}"`,
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
    });

    broadcastToAdmins("dashboard:update", {
      type: "ticket",
      action: "deleted",
      ticketId: ticket._id,
    });

    return res.status(200).json({
      success: true,
      message: "Ticket deleted successfully",
    });
  } catch (error) {
    console.error("DELETE TICKET ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get My Tickets
 * GET /api/tickets/my
 */
export const getMyTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({
      createdBy: req.user.userId,
      isDeleted: false,
    })
      .populate("createdBy", "name email profileImage")
      .populate("assignedTo", "name email profileImage")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      data: tickets,
    });
  } catch (error) {
    console.error("MY TICKETS ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Assign Ticket
 * PUT /api/tickets/:id/assign
 * Admin only
 */
export const assignTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const { assignedTo } = req.body;

    if (!assignedTo) {
      return res.status(400).json({
        success: false,
        message: "assignedTo is required",
      });
    }

    const ticket = await findTicketService(id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    const assignedUser = await User.findById(assignedTo);
    if (!assignedUser) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    const oldAssignedTo = ticket.assignedTo;
    const updatedTicket = await assignTicketService(ticket, assignedTo);

    // Notify the newly assigned user
    const notification = await createNotification({
      user: assignedTo,
      title: "Ticket Assigned",
      message: `Ticket "${updatedTicket.title}" has been assigned to you.`,
      type: "assignment",
      referenceId: updatedTicket._id,
      referenceModel: "Ticket",
    });
    sendToUser(assignedTo.toString(), "notification:new", notification);

    // Emit ticket update via socket
    sendToUser(ticket.createdBy.toString(), "ticket:updated", {
      ticketId: updatedTicket._id,
      status: updatedTicket.status,
      assignedTo: assignedUser.name,
    });
    sendToUser(ticket.createdBy.toString(), "ticket:update", {
      ticketId: updatedTicket._id,
      status: updatedTicket.status,
      assignedTo: assignedUser.name,
    });

    broadcastToAdmins("dashboard:update", {
      type: "ticket",
      action: "assigned",
      ticketId: updatedTicket._id,
    });

    await createAudit({
      user: req.user.userId,
      action: "ASSIGN",
      entity: "TICKET",
      entityId: ticket._id,
      description: `Ticket assigned to ${assignedUser.name}`,
      oldData: { assignedTo: oldAssignedTo },
      newData: { assignedTo: assignedUser._id },
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
    });

    return res.status(200).json({
      success: true,
      message: "Ticket assigned successfully",
      data: updatedTicket,
    });
  } catch (error) {
    console.error("ASSIGN TICKET ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update Ticket Status
 * PUT /api/tickets/:id/status
 */
export const updateTicketStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ["Open", "Assigned", "In Progress", "Resolved", "Closed"];
    if (!status || !validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: `Status must be one of: ${validStatuses.join(", ")}`,
      });
    }

    const ticket = await findTicketService(id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    // Users can only close/reopen their own tickets
    if (req.user.role === "user") {
      if (ticket.createdBy.toString() !== req.user.userId) {
        return res.status(403).json({
          success: false,
          message: "Access denied",
        });
      }
      if (!["Closed", "Open"].includes(status)) {
        return res.status(403).json({
          success: false,
          message: "Users can only close or reopen their tickets",
        });
      }
    }

    const oldStatus = ticket.status;
    const updatedTicket = await updateTicketStatusService(ticket, status);

    // Notify ticket owner
    const notification = await createNotification({
      user: updatedTicket.createdBy,
      title: "Ticket Status Updated",
      message: `Your ticket "${updatedTicket.title}" status changed from ${oldStatus} to ${updatedTicket.status}.`,
      type: "status",
      referenceId: updatedTicket._id,
      referenceModel: "Ticket",
    });
    sendToUser(updatedTicket.createdBy.toString(), "notification:new", notification);

    // Real-time ticket update
    sendToUser(updatedTicket.createdBy.toString(), "ticket:updated", {
      ticketId: updatedTicket._id,
      status: updatedTicket.status,
    });
    sendToUser(updatedTicket.createdBy.toString(), "ticket:update", {
      ticketId: updatedTicket._id,
      status: updatedTicket.status,
    });

    broadcastToAdmins("dashboard:update", {
      type: "ticket",
      action: "status-updated",
      ticketId: updatedTicket._id,
      status: updatedTicket.status,
    });

    await createAudit({
      user: req.user.userId,
      action: "STATUS_CHANGE",
      entity: "TICKET",
      entityId: ticket._id,
      description: `Ticket status changed from ${oldStatus} to ${status}`,
      oldData: { status: oldStatus },
      newData: { status },
      ipAddress: req.ip,
      userAgent: req.headers["user-agent"],
    });

    return res.status(200).json({
      success: true,
      message: "Status updated successfully",
      data: updatedTicket,
    });
  } catch (error) {
    console.error("UPDATE STATUS ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
