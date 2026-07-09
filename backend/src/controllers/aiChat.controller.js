import { chatWithAI } from "../services/aiChat.service.js";
import { createAudit } from "../services/audit.service.js";

/**
 * POST /api/ai/chat
 */
export const aiChat = async (req, res) => {
  try {
    const { message, history = [] } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({
        success: false,
        message: "Message is required",
      });
    }

    const response = await chatWithAI({
      message,
      history,
    });

    // Audit Log
    if (req.user) {
      await createAudit({
        user: req.user.id,
        action: "AI_ANALYSIS",
        entity: "AI",
        description: "User interacted with AI Copilot",
        newData: {
          prompt: message,
          response,
        },
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
      });
    }

    return res.status(200).json({
      success: true,
      message: "AI response generated successfully",
      data: response,
    });
  } catch (error) {
    console.error("AI Chat Error:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to generate AI response",
      error:
        process.env.NODE_ENV === "development"
          ? error.message
          : undefined,
    });
  }
};