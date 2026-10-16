const express = require("express");
const router = express.Router();
const c = require("../controllers/authController");
const { protect } = require("../middleware/authMiddleware");

router.post("/login", c.login);
router.post("/register", c.register);
router.get("/me", protect, c.me);
module.exports = router;
