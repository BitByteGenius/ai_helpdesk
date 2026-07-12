// import express from "express";

// import protect from "../middleware/protect.js";
// import adminOnly from "../middleware/admin.middleware.js";

// import { getDashboard } from "../controllers/dashboard.controller.js";

// const router = express.Router();

// router.get("/", protect, adminOnly, getDashboard);

// export default router;


import express from "express";
import { getDashboard } from "../controllers/dashboard.controller.js";
import adminOnly from "../middleware/admin.middleware.js";
import protect from "../middleware/protect.js";

const router = express.Router();

/*
|--------------------------------------------------------------------------
| Dashboard
|--------------------------------------------------------------------------
| GET /api/dashboard
| Admin only
|--------------------------------------------------------------------------
*/

router.get(
  "/",
  protect,
  adminOnly,
  getDashboard
);

export default router;