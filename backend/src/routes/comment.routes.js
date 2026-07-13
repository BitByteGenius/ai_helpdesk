import express from "express";

import protect from "../middleware/protect.js";

import {
  createComment,
  getComments,
  updateComment,
  deleteComment,
} from "../controllers/comment.controller.js";

import {
  validateObjectId,
  validateCreateComment,
  validateUpdateComment,
  handleValidation,
} from "../validations/comment.validation.js";

const router = express.Router();

/**
 * All comment APIs require authentication
 */
router.use(protect);

/**
 * Ticket Comments
 */

// Add Comment
// POST /api/tickets/:id/comments
router.post(
  "/tickets/:id/comments",
  validateObjectId,
  validateCreateComment,
  handleValidation,
  createComment
);

// Get Comments
// GET /api/tickets/:id/comments
router.get(
  "/tickets/:id/comments",
  validateObjectId,
  handleValidation,
  getComments
);

/**
 * Comment APIs
 */

// Update Comment
// PUT /api/comments/:id
router.put(
  "/comments/:id",
  validateObjectId,
  validateUpdateComment,
  handleValidation,
  updateComment
);

// Delete Comment
// DELETE /api/comments/:id
router.delete(
  "/comments/:id",
  validateObjectId,
  handleValidation,
  deleteComment
);

export default router;