import express from "express";

import protect from "../middleware/protect.js";
import adminOnly from "../middleware/admin.middleware.js";

import {
  getAllAudits,
  getAudit,
  getUserAuditLogs,
  getEntityAuditLogs,
} from "../controllers/audit.controller.js";

const router = express.Router();

// All audit APIs are Admin Only
router.use(protect);
router.use(adminOnly);

// GET /api/audit
router.get("/", getAllAudits);

// GET /api/audit/:id
router.get("/:id", getAudit);

// GET /api/audit/user/:userId
router.get("/user/:userId", getUserAuditLogs);

// GET /api/audit/entity/:entity/:entityId
router.get(
  "/entity/:entity/:entityId",
  getEntityAuditLogs,
);

export default router;