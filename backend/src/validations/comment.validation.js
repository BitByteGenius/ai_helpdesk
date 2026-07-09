import mongoose from "mongoose";
import { body, param, validationResult } from "express-validator";

/**
 * Validate MongoDB ObjectId
 */
export const validateObjectId = [
  param("id").custom((value) => {
    if (!mongoose.Types.ObjectId.isValid(value)) {
      throw new Error("Invalid ID");
    }
    return true;
  }),
];

/**
 * Create Comment Validation
 */
export const validateCreateComment = [
  body("message")
    .trim()
    .notEmpty()
    .withMessage("Message is required")
    .isLength({ min: 2, max: 5000 })
    .withMessage("Message must be between 2 and 5000 characters"),

  body("attachments")
    .optional()
    .isArray()
    .withMessage("Attachments must be an array"),
];

/**
 * Update Comment Validation
 */
export const validateUpdateComment = [
  body("message")
    .trim()
    .notEmpty()
    .withMessage("Message is required")
    .isLength({ min: 2, max: 5000 })
    .withMessage("Message must be between 2 and 5000 characters"),
];

/**
 * Validation Result Handler
 */
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