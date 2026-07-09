import express from "express";

import protect from "../middleware/protect.js";

import {
  categoryController,
  priorityController,
  summaryController,
  replyController,
  duplicateController,
  analyzeTicketController,
} from "../controllers/ai.controller.js";

import {
  categoryValidation,
  priorityValidation,
  summaryValidation,
  replyValidation,
  duplicateValidation,
  
} from "../validations/ai.validation.js";

const router = express.Router();

/**
 * AI Category
 * POST /api/ai/category
 */
router.post(
  "/category",
  protect,
  categoryValidation,
  categoryController
);

/**
 * AI Priority
 * POST /api/ai/priority
 */
router.post(
  "/priority",
  protect,
  priorityValidation,
  priorityController
);

/**
 * AI Summary
 * POST /api/ai/summary
 */
router.post(
  "/summary",
  protect,
  summaryValidation,
  summaryController
);

/**
 * AI Reply
 * POST /api/ai/reply
 */
router.post(
  "/reply",
  protect,
  replyValidation,
  replyController
);

/**
 * AI Duplicate
 * POST /api/ai/duplicate
 */
router.post(
  "/duplicate",
  protect,
  duplicateValidation,
  duplicateController
);



router.post(

"/analyze-ticket",

protect,

duplicateValidation,

analyzeTicketController,

);

export default router;