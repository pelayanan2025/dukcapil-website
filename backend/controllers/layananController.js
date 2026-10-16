const { Layanan } = require("../models");
exports.getAllPublic = async (req, res) => { const data = await Layanan.findAll(); res.json({ success: true, data }); };
