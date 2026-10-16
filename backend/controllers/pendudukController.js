const { Penduduk } = require("../models");
exports.getAll = async (req, res) => { const data = await Penduduk.findAll(); res.json({ success: true, data }); };
