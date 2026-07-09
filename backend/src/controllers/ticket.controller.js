import mongoose from "mongoose";
import Ticket from "../models/ticket.model.js";
import {
  assignTicketService,
  findTicketService,
  updateTicketStatusService,
} from "../services/assign.ticket.service.js";


import { createNotification } from "../services/notification.service.js";
import { createAudit } from "../services/audit.service.js";





/**
 * Create Ticket
 * POST /api/tickets
 * Access: User/Admin
 */
export const createTicket = async (req, res) => {
  try {
    const { title, description, category, priority } = req.body;

    if (!title || !description) {
      return res.status(400).json({
        success: false,
        message: "Title and description are required",
      });
    }

    const ticket = await Ticket.create({
      title: title.trim(),
      description: description.trim(),
      category,
      priority,
      createdBy: req.user.userId,
    });

    // Notify all admins
const admins = await User.find({
  role: "admin",
  isDeleted: false,
});

for (const admin of admins) {
  await createNotification({
    user: admin._id,
    title: "New Ticket",
    message: `${req.user.name} created a new ticket.`,
    type: "ticket",
    referenceId: ticket._id,
    referenceModel: "Ticket",
  });
}

await createAudit({
  user: req.user.id,
  action: "CREATE",
  entity: "TICKET",
  entityId: ticket._id,
  description: "Ticket created",
  newData: ticket,
  ipAddress: req.ip,
  userAgent: req.headers["user-agent"],
});

    const populatedTicket = await Ticket.findById(ticket._id)
      .populate("createdBy", "name email profileImage");

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

    page = parseInt(page);
    limit = parseInt(limit);

    const filter = {
      isDeleted: false,
    };

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

    const ticket = await Ticket.findOne({
      _id: id,
      isDeleted: false,
    });

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

    Object.assign(ticket, req.body);

    await ticket.save();

    return res.status(200).json({
      success: true,
      message: "Ticket updated successfully",
      data: ticket,
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

    const ticket = await Ticket.findOne({
      _id: id,
      isDeleted: false,
    });

  

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

     ticket.isDeleted = true;
ticket.deletedAt = new Date();

await ticket.save();

      await createNotification({
  user: ticket.createdBy,
  title: "Ticket Deleted",
  message: `Your ticket "${ticket.title}" has been deleted.`,
  type: "ticket",
  referenceId: ticket._id,
  referenceModel: "Ticket",
});

    // User can only delete own ticket while Open
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


//Assign Ticket
export const assignTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const { assignedTo } = req.body;

    const ticket = await findTicketService(id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    const updatedTicket = await assignTicketService(ticket, assignedTo);
   // Used for Notification
    await createNotification({
  user: assignedTo,
  title: "Ticket Assigned",
  message: `Ticket "${updatedTicket.title}" has been assigned to you.`,
  type: "assignment",
  referenceId: updatedTicket._id,
  referenceModel: "Ticket",
});

await createAudit({
  user: req.user.id,
  action: "ASSIGN",
  entity: "TICKET",
  entityId: ticket._id,
  description: `Assigned ticket to ${assignedUser.name}`,
  oldData: {
    assignedTo: oldAssignedUser,
  },
  newData: {
    assignedTo: assignedUser._id,
  },
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


export const updateTicketStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const ticket = await findTicketService(id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        message: "Ticket not found",
      });
    }

    const updatedTicket = await updateTicketStatusService(
      ticket,
      status
    );

    await createNotification({
  user: updatedTicket.createdBy,
  title: "Ticket Status Updated",
  message: `Your ticket "${updatedTicket.title}" is now ${updatedTicket.status}.`,
  type: "status",
  referenceId: updatedTicket._id,
  referenceModel: "Ticket",
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
