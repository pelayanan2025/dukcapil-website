#!/usr/bin/env bash

echo "Membangun ulang struktur Backend Full..."

mkdir -p config controllers middleware models routes seeders uploads

# 1. Config Database
cat > config/database.js <<'EOF'
const { Sequelize } = require("sequelize");
require("dotenv").config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD || "",
  {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    dialect: "mysql",
    logging: false,
    timezone: "+07:00",
    dialectOptions: { dateStrings: true }
  }
);
module.exports = sequelize;
EOF

# 2. Models
cat > models/User.js <<'EOF'
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
EOF

cat > models/Penduduk.js <<'EOF'
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
EOF

cat > models/Layanan.js <<'EOF'
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
EOF

cat > models/Pengajuan.js <<'EOF'
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
EOF

cat > models/index.js <<'EOF'
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
EOF

# 3. Middleware
cat > middleware/authMiddleware.js <<'EOF'
const jwt = require("jsonwebtoken");
const { User } = require("../models");

const respond = (res, status, success, message, data = null) => res.status(status).json({ success, message, data });

exports.protect = async (req, res, next) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith("Bearer ")) return respond(res, 401, false, "Token tidak ditemukan. Silakan login.");

    const token = header.split(" ")[1];
    let decoded;
    try { decoded = jwt.verify(token, process.env.JWT_SECRET); } 
    catch { return respond(res, 401, false, "Token tidak valid atau kedaluwarsa."); }

    const user = await User.findByPk(decoded.id, { attributes: { exclude: ["password"] } });
    if (!user) return respond(res, 401, false, "User tidak ditemukan.");
    if (!user.is_active) return respond(res, 403, false, "Akun dinonaktifkan.");

    req.user = user;
    next();
  } catch (error) {
    return respond(res, 500, false, "Terjadi kesalahan pada server (auth).");
  }
};

exports.adminOnly = (req, res, next) => {
  if (req.user?.role !== "admin") return respond(res, 403, false, "Akses ditolak. Khusus admin.");
  next();
};

exports.userOnly = (req, res, next) => {
  if (req.user?.role !== "user") return respond(res, 403, false, "Akses ditolak. Khusus user.");
  next();
};
EOF

cat > middleware/uploadMiddleware.js <<'EOF'
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const dest = path.join(__dirname, "..", "uploads", "dokumen_pendukung");
    if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
    cb(null, dest);
  },
  filename: (req, file, cb) => {
    const unique = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    cb(null, `${unique}-${file.originalname.replace(/[^a-zA-Z0-9.]/g, "_")}`);
  }
});

module.exports = multer({ storage, limits: { fileSize: 5 * 1024 * 1024 } });
EOF

# 4. Controllers (Singkat & Padat)
cat > controllers/authController.js <<'EOF'
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
EOF

cat > controllers/pendudukController.js <<'EOF'
const { Penduduk } = require("../models");
exports.getAll = async (req, res) => { const data = await Penduduk.findAll(); res.json({ success: true, data }); };
EOF

cat > controllers/layananController.js <<'EOF'
const { Layanan } = require("../models");
exports.getAllPublic = async (req, res) => { const data = await Layanan.findAll(); res.json({ success: true, data }); };
EOF

cat > controllers/pengajuanController.js <<'EOF'
const { Pengajuan, Layanan, User } = require("../models");
exports.getAll = async (req, res) => { 
  const where = req.user.role === "user" ? { user_id: req.user.id } : {};
  const data = await Pengajuan.findAll({ where, include: [{model: Layanan, as: "layanan"}] });
  res.json({ success: true, data }); 
};
EOF

cat > controllers/dashboardController.js <<'EOF'
const { User, Penduduk, Layanan, Pengajuan } = require("../models");
exports.getStats = async (req, res) => {
  res.json({ success: true, data: {
    totalUser: await User.count(), totalPenduduk: await Penduduk.count(),
    totalLayanan: await Layanan.count(), totalPengajuan: await Pengajuan.count()
  }});
};
EOF

# 5. Routes
cat > routes/authRoutes.js <<'EOF'
const express = require("express");
const router = express.Router();
const c = require("../controllers/authController");
const { protect } = require("../middleware/authMiddleware");

router.post("/login", c.login);
router.post("/register", c.register);
router.get("/me", protect, c.me);
module.exports = router;
EOF

cat > routes/pendudukRoutes.js <<'EOF'
const express = require("express");
const router = express.Router();
const c = require("../controllers/pendudukController");
router.get("/", c.getAll);
module.exports = router;
EOF

cat > routes/layananRoutes.js <<'EOF'
const express = require("express");
const router = express.Router();
const c = require("../controllers/layananController");
router.get("/", c.getAllPublic);
module.exports = router;
EOF

cat > routes/pengajuanRoutes.js <<'EOF'
const express = require("express");
const router = express.Router();
const c = require("../controllers/pengajuanController");
const { protect } = require("../middleware/authMiddleware");
router.get("/", protect, c.getAll);
module.exports = router;
EOF

cat > routes/dashboardRoutes.js <<'EOF'
const express = require("express");
const router = express.Router();
const c = require("../controllers/dashboardController");
router.get("/stats", c.getStats);
module.exports = router;
EOF

# 6. Seeder Lengkap
cat > seeders/seeder.js <<'EOF'
const bcrypt = require("bcryptjs");
const { sequelize, User, Layanan } = require("../models");

async function run() {
  await sequelize.sync({ force: true });
  const adminPassword = await bcrypt.hash("admin123", 12);
  
  await User.create({
    nik: "3200000000000001", nama_lengkap: "Admin Dukcapil",
    email: "admin@dukcapil.go.id", password: adminPassword, role: "admin"
  });

  await Layanan.create({ nama_layanan: "KTP Elektronik", kode_layanan: "KTP", kategori: "KTP", estimasi_waktu: "7 Hari" });
  await Layanan.create({ nama_layanan: "Kartu Keluarga", kode_layanan: "KK", kategori: "KK", estimasi_waktu: "5 Hari" });

  console.log("✅ Seeder Selesai! Login: admin@dukcapil.go.id / admin123");
  process.exit(0);
}
run();
EOF

# 7. Server.js Final
cat > server.js <<'EOF'
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");
const { sequelize } = require("./models");

const app = express();
app.use(cors());
app.use(express.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/penduduk", require("./routes/pendudukRoutes"));
app.use("/api/layanan", require("./routes/layananRoutes"));
app.use("/api/pengajuan", require("./routes/pengajuanRoutes"));
app.use("/api/dashboard", require("./routes/dashboardRoutes"));

const PORT = process.env.PORT || 5000;
sequelize.authenticate().then(() => {
  app.listen(PORT, () => console.log(`✅ Backend jalan di http://localhost:${PORT}`));
});
EOF

echo "✅ Script backend selesai dijalankan!"