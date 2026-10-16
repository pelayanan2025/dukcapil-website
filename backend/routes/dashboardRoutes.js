const express = require("express");
const router = express.Router();
const c = require("../controllers/dashboardController");
router.get("/stats", c.getStats);
module.exports = router;
