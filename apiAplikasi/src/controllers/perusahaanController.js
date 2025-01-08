const PerusahaanModel = require("../models/perusahaanModel");
const ResponseHandler = require("../utils/responseHandler");

class perusahaanController{
    static createPerusahaan(req, res) {
    const { username, email, password, nomorHP, namaBisnis } = req.body;
    if (!username || !email || !password || !nomorHP || !namaBisnis) {
        return ResponseHandler.error(res, 400, "Semua field harus diisi");
    }
    PerusahaanModel.createPerusahaan(username, email, password, nomorHP, namaBisnis, (error, result) => {
        if (error) {
        return ResponseHandler.error(res, 400, error.message);
        }
        PerusahaanModel.ambilSemuaPerusahaan((error, perusahaans) => {
        if (error) {
            return ResponseHandler.error(res, 400, error.message);
        }
        ResponseHandler.sukses(res, 201, perusahaans);
        });
    });
    }
    static ambilPerusahaanByEmail(req, res) {
        console.log("Mengambil semua data pekerja...");
        const {email} = req.body;
        PerusahaanModel.ambilPerusahaanByEmail(email,(error, pekerjas) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, pekerjas);
        });
      }
      static async logIn(req, res) {
        try {
            const { email, password } = req.body;
    
            const user = await PerusahaanModel.logIn(email, password);
    
            if (!user) {
                return res.status(200).send({ message: 'Invalid email or password', passwordCorrect: false});
            }
    
            return res.status(200).send({ message: 'Login successful', user, passwordCorrect: true });
        } catch (error) {
            console.error('Error during login:', error);
            return res.status(500).send({ message: 'Internal server error' , passwordCorrect: false});
        }
      }

      static async ambilPerusahaanById(req, res) {
        const {idPerusahaan} = req.body;
        PerusahaanModel.ambilPerusahaanById(idPerusahaan,(error, pekerjas) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, pekerjas);
        });
      }

      static async updatePersonal(req, res) {
        const { idPerusahaan, username, email } = req.body;
      
        if (!idPerusahaan || !email || !username) {
          return res.status(400).json({
            status: 'error',
            message: 'idPerusahaan, username, dan email wajib diisi.',
          });
        }
      
        try {
          // Cek apakah email sudah ada di database
          const emailExists = await PerusahaanModel.checkEmailExists(email, idPerusahaan);
      
          if (emailExists) {
            return res.status(200).json({
              status: 'exist',
              message: `Email "${email}" sudah digunakan oleh perusahaan lain.`,
            });
          }
      
          // Jika email unik, lanjutkan pembaruan
          await PerusahaanModel.updatePersonal(idPerusahaan, username, email);
          return res.status(200).json({
            status: 'success',
            message: 'Data personal berhasil diperbarui.',
          });
        } catch (error) {
          console.error('Error in updatePersonal:', error);
          return res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server.',
          });
        }
      }
      
    
    static async updatePerusahaan(req, res) {
      const { idPerusahaan, namaBisnis, kontakUtama, nomorHP } = req.body; // Ambil hanya yang dibutuhkan
      try {
          await PerusahaanModel.updatePerusahaan(idPerusahaan, namaBisnis, kontakUtama, nomorHP);
          res.status(200).send({ message: 'Data perusahaan berhasil diperbarui' });
      } catch (error) {
          res.status(500).send({ error: error.message });
      }
      
  }
  
  static async uploadPekerjaan(req, res) {
    const {idPerusahaan,judulPekerjaan,lokasiPekerjaan,kategoriJabatan,kategoriGaji,jenisGaji,kisaranGaji,deskripsiPekerjaan,linkReferensi, pertanyaan} = req.body;
    PerusahaanModel.uploadPekerjaan(idPerusahaan,judulPekerjaan,lokasiPekerjaan,kategoriJabatan,kategoriGaji,jenisGaji,kisaranGaji,deskripsiPekerjaan,linkReferensi, pertanyaan,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }
    

  
}
module.exports = perusahaanController;