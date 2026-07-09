import express from "express";

import protect from "../middleware/protect.js";
import upload from "../middleware/upload.middleware.js";

import {
  uploadFile,
  deleteUpload,
} from "../controllers/upload.controller.js";

const router = express.Router();

/**
 * POST /api/uploads
 * Upload single file
 */
router.post(
  "/uploads",
  protect,
  upload.single("file"),
  uploadFile
);

/**
 * DELETE /api/uploads/:id
 * Delete uploaded file
 */
router.delete(
  "/uploads/:id",
  protect,
  deleteUpload
);

export default router;