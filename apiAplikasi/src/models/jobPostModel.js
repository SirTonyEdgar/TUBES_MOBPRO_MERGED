const pool = require("../config/database");

class jobPostModel {
  static async getAllJobPosts(limit = 10, offset = 0) {
    const query = `
      SELECT pekerjaan.*, perusahaan.namaBisnis AS namaPerusahaan
      FROM pekerjaan
      LEFT JOIN perusahaan ON pekerjaan.idPerusahaan = perusahaan.idPerusahaan
      LIMIT ? OFFSET ?
    `;

    try {
      const [results] = await pool.promise().query(query, [limit, offset]);
      return results;
    } catch (error) {
      console.error("Error fetching job posts:", error);
      throw error;
    }
  }
}

module.exports = jobPostModel;
