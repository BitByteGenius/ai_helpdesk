import express from "express";
import protect from "../middleware/protect.js";
import adminOnly from "../middleware/admin.middleware.js";
import {
  getUsers,
  getUserById,
  updateUser,
  deleteUser,
  changeUserStatus,
  changeUserRole,
} from "../controllers/user.controller.js";

const router = express.Router();

router.use(protect);
router.use(adminOnly);

router.get("/", getUsers);

router.get("/:id", getUserById);

router.put("/:id", updateUser);

router.delete("/:id", deleteUser);

router.patch("/:id/status", changeUserStatus);

router.patch("/:id/role", changeUserRole);

export default router;