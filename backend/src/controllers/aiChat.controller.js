import { chatWithAICopilot } from "../services/aiChat.service.js";
import { aiProvider } from "../services/aiProvider.service.js";
import { detectDuplicate } from "../services/ai.service.js";
import AIConversation from "../models/aiConversation.model.js";
import Ticket from "../models/ticket.model.js";
import { createAudit } from "../services/audit.service.js";

/**
 * POST /api/ai/chat
 */
export const aiChat = async (req, res) => {
  try {
    const { message, conversationId } = req.body;
    const userId = req.user?.userId;

    if (!message || !message.trim()) {
      return res.status(400).json({
        success: false,
        message: "Message is required",
      });
    }

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized",
      });
    }

    const response = await chatWithAICopilot({
      userId,
      message,
      conversationId,
    });

    // Audit Log
    try {
      await createAudit({
        user: userId,
        action: "AI_CHAT",
        entity: "AI",
        description: "User interacted with AI Copilot",
        newData: {
          prompt: message,
          response: response.reply,
        },
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
      });
    } catch (auditError) {
      console.warn("AI chat audit failed (non-fatal):", auditError.message);
    }

    return res.status(200).json({
      reply: response.reply,
      canCreateTicket: response.canCreateTicket,
      conversationId: response.conversationId,
      title: response.title,
      isPinned: response.isPinned,
      messages: response.messages,
    });
  } catch (error) {
    console.error("AI Chat Error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to generate AI response",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

/**
 * POST /api/ai/create-ticket
 */
export const createTicketFromChat = async (req, res) => {
  try {
    const { conversationId, conversation } = req.body;
    let history = [];

    if (conversationId) {
      const convDoc = await AIConversation.findOne({
        _id: conversationId,
        userId: req.user.userId,
      });
      if (convDoc) {
        history = convDoc.messages.map((m) => ({
          role: m.role,
          content: m.message,
        }));
      }
    } else if (Array.isArray(conversation) && conversation.length > 0) {
      history = conversation;
    }

    if (history.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Conversation context is required",
      });
    }

    const analysis = await aiProvider.analyzeConversationForTicket(history);

    // Run duplicate check
    const existingTickets = await Ticket.find({ isDeleted: false });
    const duplicateCheck = await detectDuplicate(
      { title: analysis.title, description: analysis.description },
      existingTickets
    );

    return res.status(200).json({
      title: analysis.title,
      description: analysis.description,
      summary: analysis.summary,
      priority: analysis.priority,
      category: analysis.category,
      suggestedReply: analysis.suggestedReply,
      possibleRootCause: analysis.possibleRootCause,
      recommendedAssignmentTeam: analysis.recommendedAssignmentTeam,
      confidence: analysis.confidence,
      troubleshootingAttempted: analysis.troubleshootingAttempted,
      duplicate: duplicateCheck.duplicate,
      duplicateTicket: duplicateCheck.ticket
        ? {
            id: duplicateCheck.ticket._id,
            title: duplicateCheck.ticket.title,
            status: duplicateCheck.ticket.status,
          }
        : null,
    });
  } catch (error) {
    console.error("AI Create Ticket Draft Error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to generate ticket from chat context",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

/**
 * GET /api/ai/conversations
 */
export const getConversations = async (req, res) => {
  try {
    const userId = req.user?.userId;
    const conversations = await AIConversation.find({ userId })
      .select("title isPinned updatedAt createdAt")
      .sort({ isPinned: -1, updatedAt: -1 });

    return res.status(200).json({
      success: true,
      data: conversations,
    });
  } catch (error) {
    console.error("Fetch conversations error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to load conversations",
    });
  }
};

/**
 * GET /api/ai/conversations/:id
 */
export const getConversationDetails = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user?.userId;

    const conversation = await AIConversation.findOne({ _id: id, userId });
    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: "Conversation not found",
      });
    }

    return res.status(200).json({
      success: true,
      data: conversation,
    });
  } catch (error) {
    console.error("Fetch conversation details error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to load conversation details",
    });
  }
};

/**
 * DELETE /api/ai/conversations/:id
 */
export const deleteConversation = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user?.userId;

    const result = await AIConversation.findOneAndDelete({ _id: id, userId });
    if (!result) {
      return res.status(404).json({
        success: false,
        message: "Conversation not found or unauthorized",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Conversation deleted successfully",
    });
  } catch (error) {
    console.error("Delete conversation error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to delete conversation",
    });
  }
};

/**
 * PUT /api/ai/conversations/:id
 */
export const updateConversation = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user?.userId;
    const { title, isPinned, messages } = req.body;

    const updateData = {};
    if (typeof title === "string") updateData.title = title.trim();
    if (typeof isPinned === "boolean") updateData.isPinned = isPinned;
    if (Array.isArray(messages)) updateData.messages = messages;

    const conversation = await AIConversation.findOneAndUpdate(
      { _id: id, userId },
      updateData,
      { new: true }
    );

    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: "Conversation not found or unauthorized",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Conversation updated successfully",
      data: conversation,
    });
  } catch (error) {
    console.error("Update conversation error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to update conversation",
    });
  }
};
