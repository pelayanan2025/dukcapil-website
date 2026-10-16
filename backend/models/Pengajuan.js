const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Pengajuan = sequelize.define("Pengajuan", {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  no_pengajuan: { type: DataTypes.STRING(20), allowNull: false, unique: true },
  user_id: { type: DataTypes.INTEGER, allowNull: false },
  layanan_id: { type: DataTypes.INTEGER, allowNull: false },
  tanggal_pengajuan: { type: DataTypes.DATEONLY, allowNull: false },
  status: { type: DataTypes.ENUM("Menunggu","Diproses","Verifikasi","Disetujui","Ditolak","Selesai"), allowNull: false, defaultValue: "Menunggu" },
  catatan_pemohon: { type: DataTypes.TEXT, allowNull: true },
  catatan_admin: { type: DataTypes.TEXT, allowNull: true },
  dokumen_pendukung: { type: DataTypes.JSON, allowNull: true },
  dokumen_hasil: { type: DataTypes.STRING(255), allowNull: true },
  tanggal_selesai: { type: DataTypes.DATEONLY, allowNull: true }
}, { tableName: "pengajuan", underscored: true, timestamps: true });

module.exports = Pengajuan;
