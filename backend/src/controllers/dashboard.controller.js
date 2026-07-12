// import User from "../models/user.model.js";
// import Ticket from "../models/ticket.model.js";

// export const getDashboard = async (req, res) => {
//   try {
//     // Users
//     const totalUsers = await User.countDocuments();

//     // Tickets
//     const totalTickets = await Ticket.countDocuments({
//       isDeleted: false,
//     });

//     const open = await Ticket.countDocuments({
//       status: "Open",
//       isDeleted: false,
//     });

//     const assigned = await Ticket.countDocuments({
//       status: "Assigned",
//       isDeleted: false,
//     });

//     const inProgress = await Ticket.countDocuments({
//       status: "In Progress",
//       isDeleted: false,
//     });

//     const resolved = await Ticket.countDocuments({
//       status: "Resolved",
//       isDeleted: false,
//     });

//     const closed = await Ticket.countDocuments({
//       status: "Closed",
//       isDeleted: false,
//     });

//     // Priority
//     const low = await Ticket.countDocuments({
//       priority: "Low",
//       isDeleted: false,
//     });

//     const medium = await Ticket.countDocuments({
//       priority: "Medium",
//       isDeleted: false,
//     });

//     const high = await Ticket.countDocuments({
//       priority: "High",
//       isDeleted: false,
//     });

//     const critical = await Ticket.countDocuments({
//       priority: "Critical",
//       isDeleted: false,
//     });

//     const recentTickets = await Ticket.find({
//       isDeleted: false,
//     })
//       .populate("createdBy", "name")
//       .sort({ createdAt: -1 })
//       .limit(5);

//     const recentUsers = await User.find()
//       .sort({ createdAt: -1 })
//       .limit(5);

//     res.status(200).json({
//       success: true,
//       data: {
//         users: {
//           total: totalUsers,
//           active: totalUsers,
//           inactive: 0,
//         },

//         tickets: {
//           total: totalTickets,
//           open,
//           assigned,
//           inProgress,
//           resolved,
//           closed,
//         },

//         priority: {
//           low,
//           medium,
//           high,
//           critical,
//         },

//         status: {
//           open,
//           assigned,
//           inProgress,
//           resolved,
//           closed,
//         },

//         recentTickets,
//         recentUsers,
//       },
//     });
//   } catch (error) {
//     console.log(error);

//     res.status(500).json({
//       success: false,
//       message: error.message,
//     });
//   }
// };

import { getDashboardData } from "../services/dashboard.service.js";

export const getDashboard = async (req, res, next) => {
  try {
    const dashboard = await getDashboardData();

    return res.status(200).json({
      success: true,
      message: "Dashboard loaded successfully",
      data: dashboard,
    });
  } catch (error) {
    console.error("DASHBOARD ERROR:", error);
    return res.status(500).json({
      success: false,
      message: error.message || "Failed to load dashboard",
    });
  }
};
