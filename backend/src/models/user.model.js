import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 50,
    },

    profileImage: {
      type: String,
      default: "",
    },

    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      match: [/^\S+@\S+\.\S+$/, "Please enter a valid email"],
    },

    phone: {
      type: String,
      default: "",
      trim: true,
    },

    // Password stored as bcrypt hash; select:false excludes it from all queries
    // so it is never accidentally returned in API responses.
    password: {
      type: String,
      default: "",
      select: false,
    },

    provider: {
      type: String,
      enum: ["google", "email"],
      default: "email",
    },

    isVerified: {
  type: Boolean,
  default: false,
},

    gender: {
      type: String,
      enum: ["male", "female", "other"],
      default: "other",
    },

    city: {
      type: String,
      trim: true,
      default: "",
    },

    role: {
      type: String,
      enum: ["user", "admin"],
      default: "user",
    },

    isActive: {
  type: Boolean,
  default: true,
},

isDeleted: {
  type: Boolean,
  default: false,
},

deletedAt: {
  type: Date,
  default: null,
},

lastLogin: {
  type: Date,
  default: null,
},
  },
  { timestamps: true }
);

userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

const User = mongoose.model("User", userSchema);

export default User;