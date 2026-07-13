import express from "express";

import protect from "../middleware/protect.js";

import {
  getProfile,
  updateProfile,
  changePassword,
} from "../controllers/profile.controller.js";

const router = express.Router();

router.get(
  "/profile",
  protect,
  getProfile
);

router.put(
  "/profile",
  protect,
  updateProfile
);

router.put(
  "/change-password",
  protect,
  changePassword
);

export default router;