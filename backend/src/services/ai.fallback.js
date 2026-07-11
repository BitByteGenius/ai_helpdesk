const normalizeText = (value) => String(value ?? "").trim();

const tokenize = (value) =>
  normalizeText(value)
    .toLowerCase()
    .match(/[a-z0-9]+/g) ?? [];

const containsAny = (text, keywords) =>
  keywords.some((keyword) => text.includes(keyword));

export const fallbackSummary = (text) => {
  const cleaned = normalizeText(text).replace(/\s+/g, " ");

  if (!cleaned) {
    return "No issue details provided.";
  }

  const words = cleaned.split(" ").slice(0, 18);
  const summary = words.join(" ");

  return words.length >= 18 ? `${summary}...` : summary;
};

export const fallbackCategory = (text) => {
  const normalized = normalizeText(text).toLowerCase();

  if (
    containsAny(normalized, [
      "printer",
      "print",
      "paper jam",
      "toner",
      "scanner",
    ])
  ) {
    return "Printer";
  }

  if (
    containsAny(normalized, [
      "wifi",
      "internet",
      "network",
      "vpn",
      "dns",
      "connectivity",
      "router",
      "latency",
    ])
  ) {
    return "Network";
  }

  if (
    containsAny(normalized, [
      "login",
      "password",
      "account",
      "signin",
      "sign in",
      "mfa",
      "otp",
      "locked out",
      "access",
    ])
  ) {
    return "Account";
  }

  if (
    containsAny(normalized, [
      "virus",
      "malware",
      "phishing",
      "hacked",
      "breach",
      "suspicious",
      "security",
    ])
  ) {
    return "Security";
  }

  if (
    containsAny(normalized, [
      "email",
      "mail",
      "outlook",
      "inbox",
      "smtp",
      "spam",
    ])
  ) {
    return "Email";
  }

  if (
    containsAny(normalized, [
      "database",
      "sql",
      "mysql",
      "postgres",
      "mongodb",
      "mongo",
      "query",
    ])
  ) {
    return "Database";
  }

  if (
    containsAny(normalized, [
      "server",
      "api down",
      "backend",
      "service unavailable",
      "502",
      "503",
      "504",
    ])
  ) {
    return "Server";
  }

  if (
    containsAny(normalized, [
      "aws",
      "azure",
      "gcp",
      "cloud",
      "s3",
      "bucket",
    ])
  ) {
    return "Cloud";
  }

  if (
    containsAny(normalized, [
      "mobile",
      "android",
      "ios",
      "iphone",
      "ipad",
      "app crash",
    ])
  ) {
    return "Mobile";
  }

  if (
    containsAny(normalized, [
      "laptop",
      "desktop",
      "monitor",
      "screen",
      "battery",
      "keyboard",
      "mouse",
      "hardware",
      "overheating",
      "shutting down",
    ])
  ) {
    return "Hardware";
  }

  return "Software";
};

export const fallbackPriority = (text) => {
  const normalized = normalizeText(text).toLowerCase();

  if (
    containsAny(normalized, [
      "critical",
      "down",
      "outage",
      "cannot access",
      "can't access",
      "urgent",
      "asap",
      "security breach",
      "data loss",
    ])
  ) {
    return "Critical";
  }

  if (
    containsAny(normalized, [
      "high",
      "broken",
      "not working",
      "failed",
      "failure",
      "blocked",
      "production",
    ])
  ) {
    return "High";
  }

  if (
    containsAny(normalized, [
      "slow",
      "intermittent",
      "issue",
      "problem",
      "error",
      "bug",
      "warning",
    ])
  ) {
    return "Medium";
  }

  return "Low";
};

export const fallbackReply = (ticket = {}) => {
  const category = ticket.category || fallbackCategory(ticket.description || ticket.title);
  const priority = ticket.priority || fallbackPriority(ticket.description || ticket.title);
  const summaryText = fallbackSummary(ticket.description || ticket.title);

  const recommendations = {
    Hardware: "Please check the device power, cables, and restart the machine.",
    Software: "Please restart the app, clear cache if relevant, and note any error message.",
    Network: "Please verify Wi-Fi/VPN status and test another network if possible.",
    Account: "Please confirm your login details and reset the password if needed.",
    Security: "Please disconnect affected systems and change credentials if compromise is suspected.",
    Printer: "Please check paper, toner, and the printer connection, then try a test print.",
    Email: "Please check mailbox access, sync status, and spam or rule settings.",
    Database: "Please confirm the database service is reachable and share any query error.",
    Server: "Please verify the service health and recent deployment or outage details.",
    Cloud: "Please check cloud service status, permissions, and recent configuration changes.",
    Mobile: "Please restart the app and confirm the device OS version.",
    Other: "Please share any error message or recent change so we can narrow this down.",
  };

  return [
    `Thanks for the details. This looks like a ${priority.toLowerCase()} priority ${category.toLowerCase()} issue.`,
    recommendations[category] ?? recommendations.Other,
    `Summary: ${summaryText}`,
  ].join(" ");
};

export const fallbackDuplicateDetection = (newTicket, existingTickets = []) => {
  const newTokens = new Set(
    tokenize(`${newTicket?.title ?? ""} ${newTicket?.description ?? ""}`)
  );

  let bestMatch = null;
  let bestScore = 0;

  for (const ticket of existingTickets) {
    const existingTokens = new Set(
      tokenize(`${ticket?.title ?? ""} ${ticket?.description ?? ""}`)
    );

    if (newTokens.size === 0 || existingTokens.size === 0) continue;

    let intersection = 0;

    for (const token of newTokens) {
      if (existingTokens.has(token)) intersection += 1;
    }

    const score = intersection / Math.max(newTokens.size, existingTokens.size);

    if (score > bestScore) {
      bestScore = score;
      bestMatch = ticket;
    }
  }

  return {
    duplicate: bestScore >= 0.35 && bestMatch !== null,
    ticket: bestScore >= 0.35 ? bestMatch : null,
  };
};

export const fallbackChatResponse = ({
  message,
  history = [],
  duplicateTicket = null,
}) => {
  const category = fallbackCategory(message);
  const priority = fallbackPriority(message);
  const summary = fallbackSummary(message);

  const reply = fallbackReply({
    title: message,
    description: message,
    category,
    priority,
  });

  return {
    reply,
    category,
    priority,
    summary,
    ticketSuggested: true,
    createTicket: true,
    duplicate: Boolean(duplicateTicket),
    duplicateTicket: duplicateTicket
      ? {
          id: duplicateTicket._id ?? duplicateTicket.id ?? null,
          title: duplicateTicket.title ?? "",
          status: duplicateTicket.status ?? "",
        }
      : null,
    articles: [],
    history,
  };
};
