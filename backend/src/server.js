// import "./config/env.js";

// import mongoose from "mongoose";
// import app from "./app.js";
// import http from "http";
// import { initializeSocket } from "../socket/socket.js";

// const server = http.createServer(app);
// initializeSocket(server);

// const PORT = process.env.PORT || 5000;

// const startServer = async () => {
//   try {
//     await mongoose.connect(process.env.MONGO_URI);
//     console.log("✅ MongoDB Connected");

//     server.listen(PORT, () => {
//       console.log(`🚀 Server running on port ${PORT}`);
//     });
//   } catch (err) {
//     console.error("❌ MongoDB Connection Error:", err.message);
//     process.exit(1);
//   }
// };

// startServer();

// const shutdown = (signal) => {
//   console.log(`${signal} received. Shutting down gracefully...`);
//   server.close(() => {
//     mongoose.connection.close();
//     process.exit(0);
//   });
// };

// process.on("SIGTERM", () => shutdown("SIGTERM"));
// process.on("SIGINT", () => shutdown("SIGINT"));


import "./config/env.js";

import mongoose from "mongoose";
import app from "./app.js";
import http from "http";
import { initializeSocket } from "../socket/socket.js";

const server = http.createServer(app);

initializeSocket(server);

const PORT = process.env.PORT || 5000;

const startServer = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ MongoDB Connected");

    server.listen(PORT, "0.0.0.0", () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  } catch (err) {
    console.error("❌ MongoDB Connection Error:", err.message);
    process.exit(1);
  }
};

startServer();

const shutdown = (signal) => {
  console.log(`${signal} received. Shutting down gracefully...`);

  server.close(async () => {
    try {
      await mongoose.connection.close();
      console.log("✅ MongoDB connection closed");
      process.exit(0);
    } catch (err) {
      console.error("❌ Shutdown error:", err.message);
      process.exit(1);
    }
  });
};

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));