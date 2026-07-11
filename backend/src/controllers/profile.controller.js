import bcrypt from "bcryptjs";
import User from "../models/user.model.js";
import { createAudit } from "../services/audit.service.js";

//
// GET /api/users/profile
//
export const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.userId).select("-password");

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    console.error("Get Profile Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch profile",
    });
  }
};

//
// PUT /api/users/profile
//
export const updateProfile = async (req, res) => {
  try {
    const {
      name,
      email,
      phone,
      city,
      gender,
      profileImage,
    } = req.body;

    const user = await User.findById(req.user.userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    const oldData = {
      name: user.name,
      email: user.email,
      phone: user.phone,
      city: user.city,
      gender: user.gender,
      profileImage: user.profileImage,
    };

    // Check email uniqueness
    if (email && email !== user.email) {
      const exists = await User.findOne({
        email,
        _id: { $ne: user._id },
      });

      if (exists) {
        return res.status(400).json({
          success: false,
          message: "Email already exists",
        });
      }

      user.email = email;
    }

    if (name !== undefined) user.name = name;
    if (phone !== undefined) user.phone = phone;
    if (city !== undefined) user.city = city;
    if (gender !== undefined) user.gender = gender;
    if (profileImage !== undefined) {
      user.profileImage = profileImage;
    }

    await user.save();

    const updatedUser = await User.findById(user._id).select("-password");

    try {
      await createAudit({
        user: req.user.userId,
        action: "PROFILE_UPDATE",
        entity: "PROFILE",
        entityId: req.user.userId,
        description: "Updated profile information",
        oldData,
        newData: {
          name: updatedUser.name,
          email: updatedUser.email,
          phone: updatedUser.phone,
          city: updatedUser.city,
          gender: updatedUser.gender,
          profileImage: updatedUser.profileImage,
        },
        ipAddress: req.ip,
        userAgent: req.headers["user-agent"],
      });
    } catch (auditError) {
      console.warn("Profile audit failed (non-fatal):", auditError.message);
    }

    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      data: updatedUser,
    });
  } catch (error) {
    console.error("Update Profile Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to update profile",
    });
  }
};

//
// PUT /api/users/change-password
//
export const changePassword = async (req, res) => {
  try {
    const {
      currentPassword,
      newPassword,
    } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message:
          "Current password and new password are required",
      });
    }

    const user = await User.findById(req.user.userId).select("+password");

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Google account
    if (user.provider === "google") {
      return res.status(400).json({
        success: false,
        message:
          "Google account password cannot be changed here.",
      });
    }

    const match = await bcrypt.compare(
      currentPassword,
      user.password,
    );

    if (!match) {
      return res.status(400).json({
        success: false,
        message: "Current password is incorrect",
      });
    }

    user.password = await bcrypt.hash(newPassword, 10);

    await user.save();

    res.status(200).json({
      success: true,
      message: "Password changed successfully",
    });
  } catch (error) {
    console.error("Change Password Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to change password",
    });
  }
};
