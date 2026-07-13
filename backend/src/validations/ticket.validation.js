import mongoose from "mongoose";
import { body, param, validationResult } from "express-validator";

// Validate MongoDB ObjectId
export const validateObjectId = [
  param("id").custom((value) => {
    if (!mongoose.Types.ObjectId.isValid(value)) {
      throw new Error("Invalid Ticket ID");
    }
    return true;
  }),
];

// Create Ticket Validation
export const validateCreateTicket = [
  body("title")
    .trim()
    .notEmpty()
    .withMessage("Title is required")
    .isLength({ min: 5, max: 150 })
    .withMessage("Title must be between 5 and 150 characters"),

  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required")
    .isLength({ min: 10 })
    .withMessage("Description must be at least 10 characters"),

  body("category")
    .optional()
    .isIn([
      "Hardware",
      "Software",
      "Network",
      "Email",
      "Security",
      "Account",
      "Printer",
      "Internet",
      "Other",
    ])
    .withMessage("Invalid category"),

  body("priority")
    .optional()
    .isIn(["Low", "Medium", "High", "Critical"])
    .withMessage("Invalid priority"),
];

// Update Ticket Validation
export const validateUpdateTicket = [
  body("title")
    .optional()
    .trim()
    .isLength({ min: 5, max: 150 })
    .withMessage("Title must be between 5 and 150 characters"),

  body("description")
    .optional()
    .trim()
    .isLength({ min: 10 })
    .withMessage("Description must be at least 10 characters"),

  body("category")
    .optional()
    .isIn([
      "Hardware",
      "Software",
      "Network",
      "Email",
      "Security",
      "Account",
      "Printer",
      "Internet",
      "Other",
    ])
    .withMessage("Invalid category"),

    body("summary")
  .optional()
  .isString()
  .isLength({ max: 5000 })
  .withMessage("Summary is too long"),

body("duplicateTicket")
  .optional()
  .custom((value) => {
    if (typeof value === "boolean") return true;
    if (mongoose.Types.ObjectId.isValid(value)) return true;
    throw new Error("Invalid duplicate ticket");
  }),

body("attachments")
  .optional()
  .isArray()
  .withMessage("Attachments must be an array"),

  body("priority")
    .optional()
    .isIn(["Low", "Medium", "High", "Critical"])
    .withMessage("Invalid priority"),

  body("status")
    .optional()
    .isIn([
      "Open",
      "Assigned",
      "In Progress",
      "Resolved",
      "Closed",
      "Rejected",
    ])
    .withMessage("Invalid status"),
];

// Validation Result Handler
export const handleValidation = (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res.status(422).json({
      success: false,
      message: "Validation failed",
      errors: errors.array(),
    });
  }

  next();
};



// Assign Ticket Validation
export const validateAssignTicket = [
  body("assignedTo")
    .notEmpty()
    .withMessage("assignedTo is required")
    .isMongoId()
    .withMessage("Invalid User ID"),
];

export const validateTicketStatus = [
  body("status")
    .notEmpty()
    .withMessage("Status is required")
    .isIn([
      "Open",
      "Assigned",
      "In Progress",
      "Resolved",
      "Closed",
      "Rejected",
    ])
    .withMessage("Invalid ticket status"),
];