import AIConversation from "../models/aiConversation.model.js";
import { aiProvider } from "./aiProvider.service.js";
import model, { isGeminiConfigured } from "../config/ai.config.js";

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
    const defaultTitle = safeMessage.substring(0, 40) + (safeMessage.length > 40 ? "..." : "");
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
  const escalationCues = [
    "connect me to support",
    "raise a ticket",
    "create a ticket",
    "create ticket",
    "open a ticket",
    "submit a ticket",
    "generate a ticket",
    "talk to human",
    "contact support",
    "human support",
  ];
  const isEscalation = escalationCues.some((cue) => lowerMsg.includes(cue));

  let reply = "";
  let canCreateTicket = false;

  if (isEscalation) {
    reply = "It looks like this issue couldn't be resolved here.\nWould you like me to create a support ticket using this conversation?";
    canCreateTicket = true;
  } else {
    // Call the AI provider abstraction
    const aiResult = await aiProvider.chat(formattedHistory);
    reply = aiResult.reply;
    canCreateTicket = aiResult.canCreateTicket;
  }

  // 4. Append Assistant Message
  conversationDoc.messages.push({
    role: "assistant",
    message: reply,
    timestamp: new Date(),
  });

  // 5. AI-generated Title renaming (on first assistant reply / 2nd total message)
  if (conversationDoc.messages.length === 2 && isGeminiConfigured && model) {
    try {
      const titlePrompt = `Analyze the user's issue and return a very short, summarized conversation title (max 5 words) representing the issue. Do NOT use quotes, code blocks, or extra comments. Just output the clean title.\n\nIssue: ${safeMessage}`;
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
    reply,
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
