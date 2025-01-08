const express = require("express");
const router = express.Router();
const jobPostController = require("../controllers/jobPostController");

router.get("/jobPosts", jobPostController.getAllJobPosts);
router.post("/jobPosts/apply", jobPostController.applyForJob);
router.get(
  "/recommendedQuestions/:idPekerjaan",
  jobPostController.getRecommendedQuestions
);
router.post("/jobPosts/uploadFile", jobPostController.uploadFile);

module.exports = router;
