import { Server } from "socket.io";

let io;

// Map: userId (string) → socketId (string)
const onlineUsers = new Map();

export const initializeSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: process.env.ALLOWED_ORIGINS
        ? process.env.ALLOWED_ORIGINS.split(",").map((o) => o.trim())
        : "*",
      methods: ["GET", "POST", "PUT", "DELETE"],
    },
  });

  io.on("connection", (socket) => {
    console.log(`🔌 Socket Connected: ${socket.id}`);

    // ── User joins their personal room ──────────────────────────────────
    socket.on("join", (userId) => {
      if (!userId) return;
      onlineUsers.set(userId.toString(), socket.id);
      // Also join a named room so we can target by userId
      socket.join(`user:${userId}`);
      console.log(`👤 User Joined: ${userId}`);
    });

    socket.on("join-room", (userId) => {
      if (!userId) return;
      onlineUsers.set(userId.toString(), socket.id);
      socket.join(`user:${userId}`);
    });

    // ── User joins a specific ticket room (for real-time comments) ──────
    socket.on("join-ticket", (ticketId) => {
      if (!ticketId) return;
      socket.join(`ticket:${ticketId}`);
      console.log(`🎫 Socket ${socket.id} joined ticket room: ${ticketId}`);
    });

    socket.on("join-ticket-room", (ticketId) => {
      if (!ticketId) return;
      socket.join(`ticket:${ticketId}`);
    });

    // ── User leaves a ticket room ────────────────────────────────────────
    socket.on("leave-ticket", (ticketId) => {
      if (!ticketId) return;
      socket.leave(`ticket:${ticketId}`);
      console.log(`🚪 Socket ${socket.id} left ticket room: ${ticketId}`);
    });

    socket.on("leave-ticket-room", (ticketId) => {
      if (!ticketId) return;
      socket.leave(`ticket:${ticketId}`);
    });

    // ── Admin joins the admin broadcast room ─────────────────────────────
    socket.on("join-admin", () => {
      socket.join("admin:room");
      console.log(`🔑 Admin socket ${socket.id} joined admin room`);
    });

    // ── Cleanup on disconnect ─────────────────────────────────────────────
    socket.on("disconnect", () => {
      for (const [userId, socketId] of onlineUsers.entries()) {
        if (socketId === socket.id) {
          onlineUsers.delete(userId);
          break;
        }
      }
      console.log(`❌ Socket Disconnected: ${socket.id}`);
    });
  });

  return io;
};

export const getIO = () => io;

/** Send an event to a specific user (by userId string). */
export const sendToUser = (userId, event, data) => {
  if (!io || !userId) return;
  io.to(`user:${userId}`).emit(event, data);
};

/** Send a comment/update event to all sockets in a ticket room. */
export const sendToTicketRoom = (ticketId, event, data) => {
  if (!io || !ticketId) return;
  io.to(`ticket:${ticketId}`).emit(event, data);
};

/** Broadcast an event to all connected admin sockets. */
export const broadcastToAdmins = (event, data) => {
  if (!io) return;
  io.to("admin:room").emit(event, data);
};
