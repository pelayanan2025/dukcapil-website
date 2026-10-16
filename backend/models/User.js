const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = sequelize.define("User", {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nik: { type: DataTypes.STRING(16), allowNull: false, unique: true },
  nama_lengkap: { type: DataTypes.STRING(100), allowNull: false },
  email: { type: DataTypes.STRING(100), allowNull: false, unique: true },
  password: { type: DataTypes.STRING(255), allowNull: false },
  no_telepon: { type: DataTypes.STRING(15), allowNull: true },
  alamat: { type: DataTypes.TEXT, allowNull: true },
  role: { type: DataTypes.ENUM("admin", "user"), allowNull: false, defaultValue: "user" },
  foto_profil: { type: DataTypes.STRING(255), allowNull: true },
  is_active: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: true }
}, { tableName: "users", underscored: true, timestamps: true });

module.exports = User;
