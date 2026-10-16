const express = require("express");
const router = express.Router();
const c = require("../controllers/pendudukController");
router.get("/", c.getAll);
module.exports = router;
