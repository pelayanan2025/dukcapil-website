const express = require("express");
const router = express.Router();
const c = require("../controllers/pengajuanController");
const { protect } = require("../middleware/authMiddleware");
router.get("/", protect, c.getAll);
module.exports = router;
