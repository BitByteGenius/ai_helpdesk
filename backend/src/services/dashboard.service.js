import User from "../models/user.model.js";
import Ticket from "../models/ticket.model.js";

export const getDashboardData = async () => {
  try {
    /* ---------- Statistics ---------- */

    const [
      totalUsers,
      totalTickets,
      openTickets,
      resolvedTickets,
    ] = await Promise.all([
      User.countDocuments({ isDeleted: false }),
      Ticket.countDocuments({ isDeleted: false }),
      Ticket.countDocuments({ status: "Open", isDeleted: false }),
      Ticket.countDocuments({ status: "Resolved", isDeleted: false }),
    ]);

    /* ---------- Ticket Status ---------- */

    const statusAgg = await Ticket.aggregate([
      { $match: { isDeleted: false } },
      {
        $group: {
          _id: "$status",
          count: { $sum: 1 },
        },
      },
    ]);

    const ticketStatus = {
      Open: 0,
      Assigned: 0,
      "In Progress": 0,
      Resolved: 0,
      Closed: 0,
      Rejected: 0,
    };

    statusAgg.forEach((item) => {
      if (item?._id) {
        ticketStatus[item._id] = item.count;
      }
    });

    /* ---------- Priority ---------- */

    const priorityAgg = await Ticket.aggregate([
      { $match: { isDeleted: false } },
      {
        $group: {
          _id: "$priority",
          count: { $sum: 1 },
        },
      },
    ]);

    const priority = {
      Low: 0,
      Medium: 0,
      High: 0,
      Critical: 0,
    };

    priorityAgg.forEach((item) => {
      if (item?._id) {
        priority[item._id] = item.count;
      }
    });

    /* ---------- Recent Tickets ---------- */

    const recentTickets = await Ticket.find({ isDeleted: false })
      .populate("createdBy", "name email role profileImage")
      .sort({ createdAt: -1 })
      .limit(10)
      .lean();

    /* ---------- Recent Users ---------- */

    const recentUsers = await User.find({ isDeleted: false })
      .sort({ createdAt: -1 })
      .limit(10)
      .lean();

    /* ---------- AI Insights ---------- */

    const [
      totalAnalysis,
      duplicates,
      suggestedReplies,
    ] = await Promise.all([
      Ticket.countDocuments({ aiSummary: { $ne: "" }, isDeleted: false }),
      Ticket.countDocuments({ duplicateTicket: { $ne: null }, isDeleted: false }),
      Ticket.countDocuments({ aiSuggestedReply: { $ne: "" }, isDeleted: false }),
    ]);

    return {
      stats: {
        totalTickets,
        open: openTickets,
        resolved: resolvedTickets,
        users: totalUsers,
      },

      ticketStatus,

      priority,

      recentTickets,

      recentUsers,

      aiInsights: {
        totalAnalysis,
        duplicates,
        suggestedReplies,
      },
    };
  } catch (error) {
    console.error("Dashboard service error:", error);
    return {
      stats: {
        totalTickets: 0,
        open: 0,
        resolved: 0,
        users: 0,
      },
      ticketStatus: {
        Open: 0,
        Assigned: 0,
        "In Progress": 0,
        Resolved: 0,
        Closed: 0,
        Rejected: 0,
      },
      priority: {
        Low: 0,
        Medium: 0,
        High: 0,
        Critical: 0,
      },
      recentTickets: [],
      recentUsers: [],
      aiInsights: {
        totalAnalysis: 0,
        duplicates: 0,
        suggestedReplies: 0,
      },
    };
  }
};
