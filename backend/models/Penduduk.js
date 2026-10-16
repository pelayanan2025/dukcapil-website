const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Penduduk = sequelize.define("Penduduk", {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nik: { type: DataTypes.STRING(16), allowNull: false, unique: true },
  nama_lengkap: { type: DataTypes.STRING(100), allowNull: false },
  tempat_lahir: { type: DataTypes.STRING(50), allowNull: false },
  tanggal_lahir: { type: DataTypes.DATEONLY, allowNull: false },
  jenis_kelamin: { type: DataTypes.ENUM("Laki-laki", "Perempuan"), allowNull: false },
  alamat: { type: DataTypes.TEXT, allowNull: false },
  rt: { type: DataTypes.STRING(3), allowNull: false },
  rw: { type: DataTypes.STRING(3), allowNull: false },
  kelurahan: { type: DataTypes.STRING(50), allowNull: false },
  kecamatan: { type: DataTypes.STRING(50), allowNull: false },
  kabupaten_kota: { type: DataTypes.STRING(50), allowNull: false },
  provinsi: { type: DataTypes.STRING(50), allowNull: false },
  agama: { type: DataTypes.ENUM("Islam","Kristen","Katolik","Hindu","Buddha","Konghucu"), allowNull: false },
  status_perkawinan: { type: DataTypes.ENUM("Belum Kawin","Kawin","Cerai Hidup","Cerai Mati"), allowNull: false },
  pekerjaan: { type: DataTypes.STRING(50), allowNull: true },
  kewarganegaraan: { type: DataTypes.ENUM("WNI","WNA"), allowNull: false, defaultValue: "WNI" },
  no_kk: { type: DataTypes.STRING(16), allowNull: false },
  status_dalam_keluarga: { type: DataTypes.ENUM("Kepala Keluarga","Istri","Anak","Lainnya"), allowNull: false },
  golongan_darah: { type: DataTypes.ENUM("A","B","AB","O","-"), allowNull: false, defaultValue: "-" }
}, { tableName: "penduduk", underscored: true, timestamps: true });

module.exports = Penduduk;
