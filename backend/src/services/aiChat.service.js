import AIConversation from "../models/aiConversation.model.js";
import { aiProvider } from "./aiProvider.service.js";
import model from "../config/ai.config.js";
/**
 * Persisted AI Copilot Conversation Handler
 */
export const chatWithAICopilot = async ({
  userId,
  message,
  conversationId = null,
}) => {
  const safeMessage = String(message ?? "").trim();
  let conversationDoc;

  if (conversationId) {
    conversationDoc = await AIConversation.findOne({
      _id: conversationId,
      userId,
    });
  }

  // If no conversation found or ID not provided, start a new one
  if (!conversationDoc) {
   const defaultTitle =
  safeMessage.length > 40
      ? "${safeMessage.substring(0, 40)}..."
      : safeMessage;
    conversationDoc = new AIConversation({
      userId,
      title: defaultTitle,
      messages: [],
    });
  }

  // 1. Append User Message
  conversationDoc.messages.push({
    role: "user",
    message: safeMessage,
    timestamp: new Date(),
  });

  // Save user message first to persist history in case of AI failures
  await conversationDoc.save();

  // 2. Format history for AI provider
  const formattedHistory = conversationDoc.messages.map((m) => ({
    role: m.role,
    content: m.message,
  }));

  // 3. Smart Escalation Cue Detection
  const lowerMsg = safeMessage.toLowerCase();

const ticketKeywords = [
  "create ticket",
  "create a ticket",
  "raise ticket",
  "raise a ticket",
  "open ticket",
  "open a ticket",
  "submit ticket",
  "submit a ticket",
  "generate ticket",
  "contact support",
  "connect me to support",
  "talk to support",
  "talk to human",
  "human support",
];

const canCreateTicket = ticketKeywords.some((keyword) =>
  lowerMsg.includes(keyword),
);

let reply;

if (canCreateTicket) {
  reply = `I can create a support ticket from this conversation.

Please review the conversation once, and when you're ready press **Create Ticket**.`;
} else {
  const aiResult = await aiProvider.chat(formattedHistory);
  reply = aiResult.reply;
}

  // 4. Append Assistant Message
  conversationDoc.messages.push({
  role: "assistant",
  message: reply.trim(),
  timestamp: new Date(),
});

  // 5. AI-generated Title renaming (on first assistant reply / 2nd total message)
  if (conversationDoc.messages.length === 2 && model) {
    try {
      const defaultTitle =
  safeMessage.length > 40
      ? "${safeMessage.substring(0, 40)}..."
      : safeMessage;
      const titleResult = await model.generateContent(titlePrompt);
      const titleText = titleResult?.response?.text?.() ?? "";
      const cleanedTitle = titleText.trim().replace(/^["']|["']$/g, "");
      if (cleanedTitle && cleanedTitle.length > 3) {
        conversationDoc.title = cleanedTitle;
      }
    } catch (titleError) {
      console.warn("AI title generation failed (non-fatal):", titleError.message);
    }
  }

  await conversationDoc.save();

  return {
    conversationId: conversationDoc._id,
    title: conversationDoc.title,
    isPinned: conversationDoc.isPinned,
    reply: reply.trim(),
    canCreateTicket,
    messages: conversationDoc.messages,
  };
};

/**
 * Legacy support for direct chatWithAI wrapper
 */
export const chatWithAI = async ({ message, history = [] }) => {
  const lastUserMessage = message;
  const conversation = history.map((h) => ({
    role: h.isUser ? "user" : "assistant",
    content: h.message,
  }));
  conversation.push({ role: "user", content: lastUserMessage });

  const aiResult = await aiProvider.chat(conversation);
  return {
    reply: aiResult.reply,
    ticketSuggested: aiResult.canCreateTicket,
    createTicket: aiResult.canCreateTicket,
    articles: [],
  };
};
