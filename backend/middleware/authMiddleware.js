const jwt = require("jsonwebtoken");
const { User } = require("../models");

const respond = (res, status, success, message, data = null) => res.status(status).json({ success, message, data });

exports.protect = async (req, res, next) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith("Bearer ")) return respond(res, 401, false, "Token tidak ditemukan. Silakan login.");

    const token = header.split(" ")[1];
    let decoded;
    try { decoded = jwt.verify(token, process.env.JWT_SECRET); } 
    catch { return respond(res, 401, false, "Token tidak valid atau kedaluwarsa."); }

    const user = await User.findByPk(decoded.id, { attributes: { exclude: ["password"] } });
    if (!user) return respond(res, 401, false, "User tidak ditemukan.");
    if (!user.is_active) return respond(res, 403, false, "Akun dinonaktifkan.");

    req.user = user;
    next();
  } catch (error) {
    return respond(res, 500, false, "Terjadi kesalahan pada server (auth).");
  }
};

exports.adminOnly = (req, res, next) => {
  if (req.user?.role !== "admin") return respond(res, 403, false, "Akses ditolak. Khusus admin.");
  next();
};

exports.userOnly = (req, res, next) => {
  if (req.user?.role !== "user") return respond(res, 403, false, "Akses ditolak. Khusus user.");
  next();
};
