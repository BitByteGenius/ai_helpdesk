import model, { isGeminiConfigured } from "../config/ai.config.js";
import {
  fallbackCategory,
  fallbackPriority,
  fallbackReply,
  fallbackSummary,
  fallbackChatResponse,
} from "./ai.fallback.js";

const stripCodeFences = (text) =>
  String(text ?? "")
    .replace(/```json\s*/gi, "")
    .replace(/```\s*/g, "")
    .trim();

const extractJsonObject = (text) => {
  const cleaned = stripCodeFences(text);
  const firstBrace = cleaned.indexOf("{");
  const lastBrace = cleaned.lastIndexOf("}");

  if (firstBrace === -1 || lastBrace === -1 || lastBrace <= firstBrace) {
    return null;
  }

  return cleaned.slice(firstBrace, lastBrace + 1);
};

// Abstract Base Class
class AIProvider {
  async chat(conversation) {
    throw new Error("Method 'chat' must be implemented.");
  }
  async analyzeTicket(title, description) {
    throw new Error("Method 'analyzeTicket' must be implemented.");
  }
  async generateSuggestedReply(ticket) {
    throw new Error("Method 'generateSuggestedReply' must be implemented.");
  }
  async analyzeConversationForTicket(conversation) {
    throw new Error("Method 'analyzeConversationForTicket' must be implemented.");
  }
}

// ── Gemini Implementation ──────────────────────────────────────────────
class GeminiProvider extends AIProvider {
  async chat(conversation) {
    if (!isGeminiConfigured || !model) {
      return new LocalFallbackProvider().chat(conversation);
    }

    const prompt = `
You are a helpful, friendly conversational AI assistant like Gemini.
Your first job is to respond naturally to the user's message.
Only switch into IT support mode when the user is clearly describing a real technical issue.

Rules:
1. For greetings, jokes, general knowledge, writing help, coding help, math, science, career advice, and casual conversation, respond naturally and helpfully.
2. Do not classify every message as a support issue.
3. Do not suggest or create a ticket for normal conversation.
4. Set "canCreateTicket" to true only when:
   - the user explicitly asks to create a ticket, or
   - the user says the previous troubleshooting did not work / the issue is still unresolved, or
   - the problem is clearly not solvable in chat and needs human support.
5. For general conversation, keep "canCreateTicket" false.
6. When the user is describing a technical issue, provide short, practical troubleshooting steps first.
7. Output ONLY a valid JSON object. Do not include markdown code fences. The response must match this schema:
{
  "reply": "your response to the user here (in Markdown format if formatting is helpful)",
  "canCreateTicket": true or false
}

Here is the conversation history so far:
${JSON.stringify(conversation, null, 2)}
`;

    try {
      console.log("GeminiProvider.chat prompt:", prompt);
      const result = await model.generateContent(prompt);
      const text = result?.response?.text?.() ?? "";
      console.log("GeminiProvider.chat raw response:", text);

      const jsonText = extractJsonObject(text);
      if (!jsonText) {
        return {
          reply: stripCodeFences(text) || "",
          canCreateTicket: false,
        };
      }

      try {
        const parsed = JSON.parse(jsonText);
        return {
          reply: typeof parsed.reply === "string" && parsed.reply.trim()
            ? parsed.reply.trim()
            : stripCodeFences(text) || "",
          canCreateTicket: typeof parsed.canCreateTicket === "boolean"
            ? parsed.canCreateTicket
            : false,
        };
      } catch (parseError) {
        console.error("GeminiProvider.chat JSON parse error:", parseError.message);
        return {
          reply: stripCodeFences(text) || "",
          canCreateTicket: false,
        };
      }
    } catch (error) {
      console.error("GeminiProvider chat error:", error);
      return new LocalFallbackProvider().chat(conversation);
    }
  }

  async analyzeTicket(title, description) {
    if (!isGeminiConfigured || !model) {
      return new LocalFallbackProvider().analyzeTicket(title, description);
    }

    const prompt = `
You are an AI Helpdesk Assistant.
Analyze the ticket and return ONLY JSON matching this schema:
{
  "category": "",
  "priority": "",
  "summary": ""
}
Category must be one of: Hardware, Software, Network, Account, Security, Printer, Email, Database, Server, Cloud, Mobile, Other.
Priority must be one of: Low, Medium, High, Critical.
Summary should be a brief description (under 20 words).

Ticket:
Title: ${title}
Description: ${description}
`;

    try {
      console.log("GeminiProvider.analyzeTicket prompt:", prompt);
      const result = await model.generateContent(prompt);
      const text = result?.response?.text?.() ?? "";
      console.log("GeminiProvider.analyzeTicket raw response:", text);
      const cleanText = extractJsonObject(text) ?? stripCodeFences(text);
      const parsed = JSON.parse(cleanText);
      return {
        category: parsed.category || "Other",
        priority: parsed.priority || "Medium",
        summary: parsed.summary || description.substring(0, 100),
      };
    } catch (error) {
      console.error("GeminiProvider analyzeTicket error:", error);
      return new LocalFallbackProvider().analyzeTicket(title, description);
    }
  }

  async generateSuggestedReply(ticket) {
    if (!isGeminiConfigured || !model) {
      return new LocalFallbackProvider().generateSuggestedReply(ticket);
    }

    const prompt = `
You are an experienced Helpdesk Support Engineer.
Generate a friendly, professional, short, and actionable suggested reply. Do not invent facts. Return only the plain reply text.

Ticket details:
Title: ${ticket.title}
Description: ${ticket.description}
Category: ${ticket.category}
Priority: ${ticket.priority}
`;

    try {
      const result = await model.generateContent(prompt);
      const replyText = result?.response?.text?.() ?? "";
      return { reply: replyText.trim() };
    } catch (error) {
      console.error("GeminiProvider generateSuggestedReply error:", error);
      return new LocalFallbackProvider().generateSuggestedReply(ticket);
    }
  }

  async analyzeConversationForTicket(conversation) {
    if (!isGeminiConfigured || !model) {
      return new LocalFallbackProvider().analyzeConversationForTicket(conversation);
    }

    const prompt = `
You are an AI Support Analyst.
Your task is to analyze a conversation between a user and a support agent, and generate structured ticket metadata.
From the conversation, generate the following fields:
1. title: A concise, clear title representing the user's issue (e.g. "Laptop keeps restarting unexpectedly").
2. description: A clear, summarized description of the user's issue, including what they've already tried and any relevant details from the chat.
3. summary: A one-sentence summary of the ticket (max 20 words).
4. priority: Predict the priority. Must be one of: Low, Medium, High, Critical.
5. category: Predict the category. Must be one of: Hardware, Software, Network, Email, Security, Account, Printer, Internet, Other.
6. suggestedReply: A helpful, friendly starting reply for a human support agent to send to the user (e.g. "A hardware inspection is recommended.").
7. possibleRootCause: The most likely technical cause of the issue (e.g. "Motherboard, RAM or power issue").
8. recommendedAssignmentTeam: The team that should handle this issue (e.g. "Hardware Support", "Network Operations", "Accounts & Access", "General Support").
9. confidence: The AI's confidence in this analysis (High, Medium, or Low).
10. troubleshootingAttempted: Bullet list of troubleshooting steps already tried by the user.

Output your response ONLY as a valid JSON object matching the following schema:
{
  "title": "",
  "description": "",
  "summary": "",
  "priority": "",
  "category": "",
  "suggestedReply": "",
  "possibleRootCause": "",
  "recommendedAssignmentTeam": "",
  "confidence": "",
  "troubleshootingAttempted": ""
}

Here is the conversation transcript:
${JSON.stringify(conversation, null, 2)}
`;

    try {
      console.log("GeminiProvider.analyzeConversationForTicket prompt:", prompt);
      const result = await model.generateContent(prompt);
      const text = result?.response?.text?.() ?? "";
      console.log("GeminiProvider.analyzeConversationForTicket raw response:", text);
      const cleanText = extractJsonObject(text) ?? stripCodeFences(text);
      const parsed = JSON.parse(cleanText);
      return {
        title: parsed.title || "Support ticket from chat",
        description: parsed.description || "Issue described in chat transcript.",
        summary: parsed.summary || "Conversation escalation.",
        priority: parsed.priority || "Medium",
        category: parsed.category || "Other",
        suggestedReply: parsed.suggestedReply || "How can I help you?",
        possibleRootCause: parsed.possibleRootCause || "Unknown",
        recommendedAssignmentTeam: parsed.recommendedAssignmentTeam || "General Support",
        confidence: parsed.confidence || "Medium",
        troubleshootingAttempted: parsed.troubleshootingAttempted || "Troubleshooting attempted.",
      };
    } catch (error) {
      console.error("GeminiProvider analyzeConversationForTicket error:", error);
      return new LocalFallbackProvider().analyzeConversationForTicket(conversation);
    }
  }
}

// ── OpenAI Implementation (Placeholder) ──────────────────────────────
class OpenAIProvider extends AIProvider {
  // Can be implemented similarly with OpenAI SDK in the future
  async chat(conversation) { return new GeminiProvider().chat(conversation); }
  async analyzeTicket(title, description) { return new GeminiProvider().analyzeTicket(title, description); }
  async generateSuggestedReply(ticket) { return new GeminiProvider().generateSuggestedReply(ticket); }
  async analyzeConversationForTicket(conversation) { return new GeminiProvider().analyzeConversationForTicket(conversation); }
}

// ── Claude Implementation (Placeholder) ──────────────────────────────
class ClaudeProvider extends AIProvider {
  async chat(conversation) { return new GeminiProvider().chat(conversation); }
  async analyzeTicket(title, description) { return new GeminiProvider().analyzeTicket(title, description); }
  async generateSuggestedReply(ticket) { return new GeminiProvider().generateSuggestedReply(ticket); }
  async analyzeConversationForTicket(conversation) { return new GeminiProvider().analyzeConversationForTicket(conversation); }
}

// ── Local Fallback Implementation ──────────────────────────────────────
class LocalFallbackProvider extends AIProvider {
  async chat(conversation) {
    const lastUserMessage = conversation.length > 0 ? conversation[conversation.length - 1].content : "";
    const fb = fallbackChatResponse({ message: lastUserMessage, history: conversation });
    return {
      reply: fb.reply,
      canCreateTicket: false,
    };
  }

  async analyzeTicket(title, description) {
    return {
      category: fallbackCategory(`${title} ${description}`),
      priority: fallbackPriority(`${title} ${description}`),
      summary: fallbackSummary(description),
    };
  }

  async generateSuggestedReply(ticket) {
    return {
      reply: fallbackReply(ticket),
    };
  }

  async analyzeConversationForTicket(conversation) {
    const fullText = conversation.map((c) => c.content).join(" ");
    const category = fallbackCategory(fullText);
    const priority = fallbackPriority(fullText);
    const summary = fallbackSummary(fullText);

    return {
      title: "Trouble with " + category,
      description: "User is experiencing an issue regarding " + category + ". Summarized transcript details: " + summary,
      summary: summary,
      priority: priority,
      category: category,
      suggestedReply: fallbackReply({ category, priority, description: fullText }),
      possibleRootCause: "Potential issue identified from chat context.",
      recommendedAssignmentTeam: category + " Support Team",
      confidence: "Low (Fallback)",
      troubleshootingAttempted: "Basic system reboot / checking power status.",
    };
  }
}

// Factory to resolve configured provider
const getAIProvider = () => {
  const selected = (process.env.AI_PROVIDER || "gemini").toLowerCase();
  switch (selected) {
    case "openai":
      return new OpenAIProvider();
    case "claude":
      return new ClaudeProvider();
    case "gemini":
    default:
      return new GeminiProvider();
  }
};

export const aiProvider = getAIProvider();
