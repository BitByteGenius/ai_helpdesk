import model from "../config/ai.config.js";

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

  const category = await generateResponse(prompt);

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

  const priority = await generateResponse(prompt);

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

  const summary = await generateResponse(prompt);

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

  const reply = await generateResponse(prompt);

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
  let bestMatch = null;

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

  const response =
      await generateResponse(prompt);

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