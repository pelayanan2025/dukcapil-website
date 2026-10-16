const sequelize = require("../config/database");
const User = require("./User");
const Penduduk = require("./Penduduk");
const Layanan = require("./Layanan");
const Pengajuan = require("./Pengajuan");

User.hasMany(Pengajuan, { foreignKey: "user_id", as: "pengajuan" });
Pengajuan.belongsTo(User, { foreignKey: "user_id", as: "user" });

Layanan.hasMany(Pengajuan, { foreignKey: "layanan_id", as: "pengajuan" });
Pengajuan.belongsTo(Layanan, { foreignKey: "layanan_id", as: "layanan" });

module.exports = { sequelize, User, Penduduk, Layanan, Pengajuan };
