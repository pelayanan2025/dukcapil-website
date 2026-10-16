const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Layanan = sequelize.define("Layanan", {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nama_layanan: { type: DataTypes.STRING(100), allowNull: false },
  kode_layanan: { type: DataTypes.STRING(20), allowNull: false, unique: true },
  deskripsi: { type: DataTypes.TEXT, allowNull: true },
  persyaratan: { type: DataTypes.JSON, allowNull: true },
  estimasi_waktu: { type: DataTypes.STRING(50), allowNull: true },
  biaya: { type: DataTypes.DECIMAL(12, 2), allowNull: false, defaultValue: 0 },
  kategori: { type: DataTypes.ENUM("KTP","KK","Akta Kelahiran","Akta Kematian","Akta Perkawinan","Pindah","Lainnya"), allowNull: false },
  is_active: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: true },
  icon: { type: DataTypes.STRING(50), allowNull: true }
}, { tableName: "layanan", underscored: true, timestamps: true });

module.exports = Layanan;
