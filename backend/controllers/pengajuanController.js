const { Pengajuan, Layanan, User } = require("../models");
exports.getAll = async (req, res) => { 
  const where = req.user.role === "user" ? { user_id: req.user.id } : {};
  const data = await Pengajuan.findAll({ where, include: [{model: Layanan, as: "layanan"}] });
  res.json({ success: true, data }); 
};
