import Ticket from "../models/ticket.model.js";

// Find Ticket
export const findTicketService = async (id) => {
  return await Ticket.findOne({
    _id: id,
    isDeleted: false,
  });
};

// Assign Ticket
export const assignTicketService = async (ticket, assignedUserId) => {
  ticket.assignedTo = assignedUserId;
  ticket.status = "Assigned";

  await ticket.save();

  return await Ticket.findById(ticket._id)
    .populate("createdBy", "name email profileImage")
    .populate("assignedTo", "name email profileImage");
};

// Update Ticket Status
export const updateTicketStatusService = async (ticket, status) => {
  ticket.status = status;

  await ticket.save();

  return await Ticket.findById(ticket._id)
    .populate("createdBy", "name email profileImage")
    .populate("assignedTo", "name email profileImage");
};