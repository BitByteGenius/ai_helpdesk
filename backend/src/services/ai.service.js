import { aiProvider } from "./aiProvider.service.js";
import model, { isGeminiConfigured } from "../config/ai.config.js";
import { fallbackDuplicateDetection } from "./ai.fallback.js";
import { DUPLICATE_PROMPT } from "../prompts/ai.prompts.js";

/**
 * Generate AI Response (legacy utility for direct prompt checks if needed)
 */
const generateResponse = async (prompt) => {
  if (!isGeminiConfigured || !model) {
    throw new Error("Gemini API key is not configured.");
  }
  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text().trim();
  } catch (error) {
    console.error("AI SERVICE ERROR:", error);
    throw new Error("AI service unavailable.");
  }
};

/**
 * Duplicate Detection
 */
export const detectDuplicate = async (newTicket, existingTickets) => {
  if (!isGeminiConfigured || !model) {
    return fallbackDuplicateDetection(newTicket, existingTickets);
  }

  let bestMatch = null;
  try {
    for (const ticket of existingTickets) {
      const prompt = `
${DUPLICATE_PROMPT}

Ticket A

Title:
${newTicket.title}

Description:
${newTicket.description}

-------------------------

Ticket B

Title:
${ticket.title}

Description:
${ticket.description}
`;

      const response = await generateResponse(prompt);
      if (response.toUpperCase().includes("YES")) {
        bestMatch = ticket;
        break;
      }
    }
  } catch {
    return fallbackDuplicateDetection(newTicket, existingTickets);
  }

  return {
    duplicate: bestMatch !== null,
    ticket: bestMatch,
  };
};

/**
 * Ticket Categorization
 */
export const categorizeTicket = async (description) => {
  const result = await aiProvider.analyzeTicket("", description);
  return { category: result.category };
};

/**
 * Priority Prediction
 */
export const predictPriority = async (description) => {
  const result = await aiProvider.analyzeTicket("", description);
  return { priority: result.priority };
};

/**
 * Ticket Summary
 */
export const summarizeTicket = async (description) => {
  const result = await aiProvider.analyzeTicket("", description);
  return { summary: result.summary };
};

/**
 * Suggested Reply
 */
export const generateReply = async (ticket) => {
  const result = await aiProvider.generateSuggestedReply(ticket);
  return { reply: result.reply };
};

/**
 * Analyze Ticket
 */
export const analyzeTicket = async (title, description, existingTickets) => {
  const result = await aiProvider.analyzeTicket(title, description);
  const duplicate = await detectDuplicate({ title, description }, existingTickets);

  return {
    category: result.category,
    priority: result.priority,
    summary: result.summary,
    duplicate: duplicate.duplicate,
    duplicateTicket: duplicate.ticket,
  };
};
