import model, { isGeminiConfigured } from "../config/ai.config.js";
import {
  fallbackCategory,
  fallbackPriority,
  fallbackReply,
  fallbackSummary,
  fallbackDuplicateDetection,
} from "./ai.fallback.js";

import {
  CATEGORY_PROMPT,
  PRIORITY_PROMPT,
  SUMMARY_PROMPT,
  REPLY_PROMPT,
  DUPLICATE_PROMPT,
  ANALYZE_PROMPT,
} from "../prompts/ai.prompts.js";

/**
 * Generate AI Response
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
 * Ticket Categorization
 */
export const categorizeTicket = async (description) => {
  const prompt = `
${CATEGORY_PROMPT}

Ticket:

${description}
`;

  let category;

  try {
    category = await generateResponse(prompt);
  } catch {
    category = fallbackCategory(description);
  }

  return {
    category,
  };
};

/**
 * Priority Prediction
 */
export const predictPriority = async (description) => {
  const prompt = `
${PRIORITY_PROMPT}

Ticket:

${description}
`;

  let priority;

  try {
    priority = await generateResponse(prompt);
  } catch {
    priority = fallbackPriority(description);
  }

  return {
    priority,
  };
};

/**
 * Ticket Summary
 */
export const summarizeTicket = async (description) => {
  const prompt = `
${SUMMARY_PROMPT}

Ticket:

${description}
`;

  let summary;

  try {
    summary = await generateResponse(prompt);
  } catch {
    summary = fallbackSummary(description);
  }

  return {
    summary,
  };
};

/**
 * Suggested Reply
 */
export const generateReply = async (ticket) => {
  const prompt = `
${REPLY_PROMPT}

Title:
${ticket.title}

Description:
${ticket.description}

Category:
${ticket.category}

Priority:
${ticket.priority}
`;

  let reply;

  try {
    reply = await generateResponse(prompt);
  } catch {
    reply = fallbackReply(ticket);
  }

  return {
    reply,
  };
};

/**
 * Duplicate Detection
 */
export const detectDuplicate = async (
  newTicket,
  existingTickets
) => {
  if (!isGeminiConfigured || !model) {
    const fallback = fallbackDuplicateDetection(
      newTicket,
      existingTickets
    );

    return fallback;
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
 * Analyze Ticket
 */
export const analyzeTicket = async (
  title,
  description,
  existingTickets
) => {

  const prompt = `
${ANALYZE_PROMPT}

Title:
${title}

Description:
${description}
`;

  let response;

  try {
    response = await generateResponse(prompt);
  } catch {
    const fallback = {
      category: fallbackCategory(`${title} ${description}`),
      priority: fallbackPriority(`${title} ${description}`),
      summary: fallbackSummary(description),
    };

    const duplicate =
      fallbackDuplicateDetection(
        {
          title,
          description,
        },
        existingTickets,
      );

    return {
      ...fallback,
      duplicate: duplicate.duplicate,
      duplicateTicket: duplicate.ticket,
    };
  }

  let aiResult;

  try {
    aiResult = JSON.parse(response);
  } catch {

    aiResult = {
      category: "Other",
      priority: "Medium",
      summary: description.substring(0, 120),
    };
  }

  const duplicate =
      await detectDuplicate(
        {
          title,
          description,
        },
        existingTickets,
      );

  return {

    category:
        aiResult.category,

    priority:
        aiResult.priority,

    summary:
        aiResult.summary,

    duplicate:
        duplicate.duplicate,

    duplicateTicket:
        duplicate.ticket,
  };
};
