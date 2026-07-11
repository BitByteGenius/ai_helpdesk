import "./env.js";

import { GoogleGenerativeAI } from "@google/generative-ai";

const apiKey = process.env.GEMINI_API_KEY?.trim();

const isGeminiConfigured = Boolean(apiKey);

const model = isGeminiConfigured
  ? new GoogleGenerativeAI(apiKey).getGenerativeModel({
      model: "gemini-2.5-flash",
    })
  : null;

export default model;
export { isGeminiConfigured };
