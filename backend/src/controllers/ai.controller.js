import { validationResult } from "express-validator";
import Ticket from "../models/ticket.model.js";
import { createAudit } from "../services/audit.service.js";
import {
  categorizeTicket,
  predictPriority,
  summarizeTicket,
  generateReply,
  detectDuplicate,
  analyzeTicket,
} from "../services/ai.service.js";

/**
 * Handle Validation Errors
 */
const handleValidation = (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    res.status(400).json({
      success: false,
      errors: errors.array(),
    });

    return false;
  }

  return true;
};

/**
 * POST /api/ai/category
 */
export const categoryController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const { description } = req.body;

    const result = await categorizeTicket(description);

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("CATEGORY ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * POST /api/ai/priority
 */
export const priorityController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const { description } = req.body;

    const result = await predictPriority(description);

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("PRIORITY ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * POST /api/ai/summary
 */
export const summaryController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const { description } = req.body;

    const result = await summarizeTicket(description);

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("SUMMARY ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * POST /api/ai/reply
 */
export const replyController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const result = await generateReply(req.body);

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("REPLY ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * POST /api/ai/duplicate
 */
export const duplicateController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const { title, description } = req.body;

    // Fetch candidate tickets
    const tickets = await Ticket.find(
      {
        isDeleted: false,
      },
      "title description status priority"
    ).limit(50);

    const result = await detectDuplicate(
      {
        title,
        description,
      },
      tickets
    );

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("DUPLICATE ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * POST /api/ai/analyze-ticket
 */
export const analyzeTicketController = async (req, res) => {
  try {
    if (!handleValidation(req, res)) return;

    const { title, description } = req.body;

    const tickets = await Ticket.find(
      { isDeleted: false },
      "title description status priority"
    ).limit(50);

    const result = await analyzeTicket(title, description, tickets);

    // Safely log audit — failure here should not crash the response
    try {
      if (req.user?.userId) {
        await createAudit({
          user: req.user.userId,
          action: "AI_ANALYSIS",
          entity: "AI",
          entityId: null,
          description: `AI analyzed ticket: "${title}"`,
          newData: {
            category: result?.category,
            priority: result?.priority,
            summary: result?.summary,
          },
          ipAddress: req.ip,
          userAgent: req.headers["user-agent"],
        });
      }
    } catch (auditErr) {
      console.warn("Audit log failed (non-fatal):", auditErr.message);
    }

    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("ANALYZE TICKET ERROR:", error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
