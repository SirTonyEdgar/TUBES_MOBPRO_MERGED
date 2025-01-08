const express = require("express");
const router = express.Router();
const pekerjaController = require("../controllers/pekerjaController");

router.post("/", pekerjaController.createPekerja);

router.post("/checkEmail", pekerjaController.ambilPekerjaByEmail);

router.post("/verifyPassword", pekerjaController.logIn);

router.post("/getDataPekerja", pekerjaController.ambilPekerjaById);

router.post("/pekerja/updateProfil", pekerjaController.updateProfil);

router.post("/updateProfilData", pekerjaController.updateProfilData);

router.post("/uploadFile", pekerjaController.uploadFile);

router.post("/ambilPekerjaById", pekerjaController.ambilPekerjaById);

router.post("/getProfileData", pekerjaController.getProfileData);

module.exports = router;
