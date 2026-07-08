import express from "express";
import protect from "../middleware/protect.js";
import adminOnly from "../middleware/admin.middleware.js";

import {
  createTicket,
  getTickets,
  getTicketById,
  updateTicket,
  deleteTicket,
  getMyTickets,
  assignTicket,
  updateTicketStatus,
} from "../controllers/ticket.controller.js";

import {
  validateCreateTicket,
  validateUpdateTicket,
  validateObjectId,
  handleValidation,
} from "../validations/ticket.validation.js";

import {
  validateAssignTicket,
  validateTicketStatus,
} from "../validations/ticket.validation.js";

const router = express.Router();

// All ticket APIs require authentication
router.use(protect);

// User's own tickets
router.get("/my", getMyTickets);

// Get all tickets
router.get("/", getTickets);

// Get single ticket
router.get("/:id", validateObjectId, handleValidation, getTicketById);

// Create ticket
router.post(
  "/",
  validateCreateTicket,
  handleValidation,
  createTicket
);

// Update ticket
router.put(
  "/:id",
  validateObjectId,
  validateUpdateTicket,
  handleValidation,
  updateTicket
);

// Delete ticket
router.delete(
  "/:id",
  validateObjectId,
  handleValidation,
  deleteTicket
);



router.put(
  "/:id/assign",
  adminOnly,
  validateObjectId,
  validateAssignTicket,
  handleValidation,
  assignTicket
);

router.patch(
  "/:id/status",
  adminOnly,
  validateObjectId,
  validateTicketStatus,
  handleValidation,
  updateTicketStatus
);

export default router;