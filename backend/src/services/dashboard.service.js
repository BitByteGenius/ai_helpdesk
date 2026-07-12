import User from "../models/user.model.js";
import Ticket from "../models/ticket.model.js";

export const getDashboardData = async () => {
  /* ---------- Statistics ---------- */

  const [
    totalUsers,
    totalTickets,
    openTickets,
    resolvedTickets,
  ] = await Promise.all([
    User.countDocuments({
      isDeleted: false,
    }),

    Ticket.countDocuments({
      isDeleted: false,
    }),

    Ticket.countDocuments({
      status: "Open",
      isDeleted: false,
    }),

    Ticket.countDocuments({
      status: "Resolved",
      isDeleted: false,
    }),
  ]);

  /* ---------- Ticket Status ---------- */

  const statusAgg = await Ticket.aggregate([
    {
      $match: {
        isDeleted: false,
      },
    },
    {
      $group: {
        _id: "$status",
        count: {
          $sum: 1,
        },
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
    ticketStatus[item._id] = item.count;
  });

  /* ---------- Priority ---------- */

  const priorityAgg = await Ticket.aggregate([
    {
      $match: {
        isDeleted: false,
      },
    },
    {
      $group: {
        _id: "$priority",
        count: {
          $sum: 1,
        },
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
    priority[item._id] = item.count;
  });

  /* ---------- Recent Tickets ---------- */

  const recentTickets = await Ticket.find({
    isDeleted: false,
  })
    .populate(
      "createdBy",
      "name email role profileImage",
    )
    .sort({
      createdAt: -1,
    })
    .limit(10);

  /* ---------- Recent Users ---------- */

  const recentUsers = await User.find({
    isDeleted: false,
  })
    .sort({
      createdAt: -1,
    })
    .limit(10);

  /* ---------- AI Insights ---------- */

  const [
    totalAnalysis,
    duplicates,
    suggestedReplies,
  ] = await Promise.all([
    Ticket.countDocuments({
      aiSummary: {
        $ne: "",
      },
      isDeleted: false,
    }),

    Ticket.countDocuments({
      duplicateTicket: {
        $ne: null,
      },
      isDeleted: false,
    }),

    Ticket.countDocuments({
      aiSuggestedReply: {
        $ne: "",
      },
      isDeleted: false,
    }),
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
};