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
