import "./env.js";
import { GoogleGenerativeAI } from "@google/generative-ai";

const apiKey = process.env.GEMINI_API_KEY?.trim() || "";

export const isGeminiConfigured = apiKey.length > 0;

let model = null;

if (isGeminiConfigured) {
  try {
    const genAI = new GoogleGenerativeAI(apiKey);

    model = genAI.getGenerativeModel({
      model: "gemini-2.5-flash",
    });

    console.log("✅ Gemini configured");
  } catch (e) {
    console.error("Failed to initialize Gemini:", e.message);
  }
} else {
  console.warn("⚠ GEMINI_API_KEY not configured");
}

export default model;