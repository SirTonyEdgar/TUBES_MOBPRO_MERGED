const express = require('express');
const perusahaanController = require('../controllers/perusahaanController');
const router = express.Router();

router.post('/daftarPerusahaan', perusahaanController.createPerusahaan);
router.post('/checkEmailPerusahaan', perusahaanController.ambilPerusahaanByEmail);
router.post('/storePerusahaan', perusahaanController.createPerusahaan);
router.post('/verifyPasswordPerusahaan',perusahaanController.logIn);
router.post('/getDataPerusahaan', perusahaanController.ambilPerusahaanById);
router.put('/updatePersonal', perusahaanController.updatePersonal);
router.put('/updatePerusahaan', perusahaanController.updatePerusahaan);
router.post('/uploadPekerjaan', perusahaanController.uploadPekerjaan);
module.exports = router;
