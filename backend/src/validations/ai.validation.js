import { body } from "express-validator";

/**
 * Category Validation
 */
export const categoryValidation = [
  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required.")
    .isLength({ min: 5 })
    .withMessage("Description must be at least 5 characters."),
];

/**
 * Priority Validation
 */
export const priorityValidation = [
  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required.")
    .isLength({ min: 5 })
    .withMessage("Description must be at least 5 characters."),
];

/**
 * Summary Validation
 */
export const summaryValidation = [
  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required.")
    .isLength({ min: 10 })
    .withMessage("Description must be at least 10 characters."),
];

/**
 * Suggested Reply Validation
 */
export const replyValidation = [
  body("title")
    .trim()
    .notEmpty()
    .withMessage("Title is required."),

  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required."),
];

/**
 * Duplicate Validation
 */
export const duplicateValidation = [
  body("title")
    .trim()
    .notEmpty()
    .withMessage("Title is required."),

  body("description")
    .trim()
    .notEmpty()
    .withMessage("Description is required."),
];