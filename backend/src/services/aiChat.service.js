import model, { isGeminiConfigured } from "../config/ai.config.js";
import Ticket from "../models/ticket.model.js";
import { fallbackChatResponse, fallbackDuplicateDetection } from "./ai.fallback.js";

const escapeRegExp = (value = "") =>
  value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/**
 * Enterprise AI Copilot
 */
export const chatWithAI = async ({
  message,
  history = [],
}) => {
  const safeMessage = String(message ?? "").trim();
  const safeHistory = Array.isArray(history) ? history : [];

  // -----------------------
  // Duplicate Detection
  // -----------------------

  let duplicateTicket = null;

  if (safeMessage) {
    try {
      duplicateTicket = await Ticket.findOne({
        $or: [
          {
            title: {
              $regex: escapeRegExp(safeMessage),
              $options: "i",
            },
          },
          {
            description: {
              $regex: escapeRegExp(safeMessage),
              $options: "i",
            },
          },
        ],
      }).select("title status");
    } catch (duplicateError) {
      console.warn("Duplicate lookup failed, using fallback:", duplicateError.message);
    }
  }

  // -----------------------
  // Prompt
  // -----------------------

  const prompt = `
You are an Enterprise AI Helpdesk Copilot.

Analyze the user's IT support issue.

Return ONLY valid JSON.

Schema:

{
  "reply":"",
  "category":"",
  "priority":"",
  "summary":"",
  "ticketSuggested":true,
  "duplicate":false,
  "articles":[]
}

Categories:

Hardware

Software

Network

Printer

Email

Account

Security

Other

Priority

Low

Medium

High

Critical

User Problem:

${safeMessage}

Conversation History:

${JSON.stringify(safeHistory, null, 2)}
`;

  if (!isGeminiConfigured || !model) {
    return fallbackChatResponse({
      message: safeMessage,
      history: safeHistory,
      duplicateTicket,
    });
  }

  let text = "";

  try {
    const result = await model.generateContent(prompt);
    text = result?.response?.text?.() ?? "";
  } catch (error) {
    const fallbackDuplicate = duplicateTicket
      ? duplicateTicket
      : fallbackDuplicateDetection(
          {
            title: safeMessage,
            description: safeMessage,
          },
          [],
        ).ticket;

    return fallbackChatResponse({
      message: safeMessage,
      history: safeHistory,
      duplicateTicket: fallbackDuplicate || duplicateTicket,
    });
  }

  let parsed;

  try {
    parsed = JSON.parse(
      text.replace(/```json|```/g, "").trim()
    );
  } catch (e) {
    parsed = fallbackChatResponse({
      message: safeMessage,
      history: safeHistory,
      duplicateTicket,
    });
  }

  // -----------------------
  // Duplicate
  // -----------------------

  if (duplicateTicket) {
    parsed.duplicate = true;

    parsed.duplicateTicket = {
      id: duplicateTicket._id,
      title: duplicateTicket.title,
      status: duplicateTicket.status,
    };
  }

  parsed.createTicket = parsed.createTicket ?? parsed.ticketSuggested ?? true;
  parsed.ticketSuggested = parsed.ticketSuggested ?? parsed.createTicket;
  parsed.articles = Array.isArray(parsed.articles) ? parsed.articles : [];

  return parsed;
};
