const { User, Penduduk, Layanan, Pengajuan } = require("../models");
exports.getStats = async (req, res) => {
  res.json({ success: true, data: {
    totalUser: await User.count(), totalPenduduk: await Penduduk.count(),
    totalLayanan: await Layanan.count(), totalPengajuan: await Pengajuan.count()
  }});
};
