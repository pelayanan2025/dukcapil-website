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
