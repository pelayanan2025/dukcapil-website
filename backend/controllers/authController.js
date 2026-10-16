const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { User } = require("../models");

const signToken = (user) => jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: "24h" });
const ok = (res, message, data = null) => res.json({ success: true, message, data });
const fail = (res, status, message) => res.status(status).json({ success: false, message });

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });
    if (!user || !(await bcrypt.compare(password, user.password))) return fail(res, 401, "Email atau password salah.");
    return ok(res, "Login berhasil", { token: signToken(user), user: { id: user.id, email: user.email, role: user.role, nama_lengkap: user.nama_lengkap } });
  } catch (err) { return fail(res, 500, "Server Error"); }
};

exports.register = async (req, res) => {
  try {
    const { nik, nama_lengkap, email, password } = req.body;
    const hashed = await bcrypt.hash(password, 12);
    const user = await User.create({ nik, nama_lengkap, email, password: hashed });
    return ok(res, "Register berhasil", { token: signToken(user), user: { id: user.id, email: user.email, role: user.role } });
  } catch (err) { return fail(res, 500, "Gagal register, pastikan NIK dan Email belum terdaftar."); }
};

exports.me = async (req, res) => ok(res, "Data user", req.user);
