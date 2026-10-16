const express = require("express");
const router = express.Router();
const c = require("../controllers/layananController");
router.get("/", c.getAllPublic);
module.exports = router;
