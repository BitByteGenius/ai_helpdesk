import model from "../config/ai.config.js";
import Ticket from "../models/ticket.model.js";

/**
 * Enterprise AI Copilot
 */
export const chatWithAI = async ({
  message,
  history = [],
}) => {
  // -----------------------
  // Duplicate Detection
  // -----------------------

  const duplicateTicket = await Ticket.findOne({
    $or: [
      {
        title: {
          $regex: message,
          $options: "i",
        },
      },
      {
        description: {
          $regex: message,
          $options: "i",
        },
      },
    ],
  }).select("title status");

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

${message}
`;

  const result = await model.generateContent(prompt);

  const text = result.response.text();

  let parsed;

  try {
    parsed = JSON.parse(
      text.replace(/```json|```/g, "")
    );
  } catch (e) {
    parsed = {
      reply: text,
      category: "Other",
      priority: "Medium",
      summary: message,
      ticketSuggested: true,
      duplicate: false,
      articles: [],
    };
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

  return parsed;
};