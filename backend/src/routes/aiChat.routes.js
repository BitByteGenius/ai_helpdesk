import express from "express";

import protect from "../middleware/protect.js";
import { aiChat } from "../controllers/aiChat.controller.js";

const router = express.Router();

// All AI chat requests require authentication
router.post("/chat", protect, aiChat);

export default router;