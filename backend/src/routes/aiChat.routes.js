import express from "express";
import protect from "../middleware/protect.js";
import {
  aiChat,
  createTicketFromChat,
  getConversations,
  getConversationDetails,
  deleteConversation,
  updateConversation,
} from "../controllers/aiChat.controller.js";

const router = express.Router();

// AI Copilot Endpoints (Authentication required)
router.post("/chat", protect, aiChat);
router.post("/create-ticket", protect, createTicketFromChat);
router.get("/conversations", protect, getConversations);
router.get("/conversations/:id", protect, getConversationDetails);
router.delete("/conversations/:id", protect, deleteConversation);
router.put("/conversations/:id", protect, updateConversation);

export default router;