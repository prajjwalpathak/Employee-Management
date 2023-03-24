const db = require("../../models");
const User = db.user;
const UserSkills = db.userSkills;
const getUserSkillsData = require("../fetchData/userSkills");
const currentUser = require('../fetchData/currentUser');

exports.postUserAddSkills = async (req, res) => {
  try {
    const response = req.body;
    const currentUserEmail = req.user.userEmail;
    const currentUser = await User.findAll({
      where: {
        email: currentUserEmail,
      },
    });
    response.userId = currentUser[0].dataValues.id;
    const userSkills = await UserSkills.create(response);
    return res.status(201).json(userSkills);
  } catch (error) {
    console.log(error);
  }
};

exports.getUserSkills = async (req, res) => {
  try {
    const currentUserEmail = req.user.userEmail;
    const userSkillsData = await getUserSkillsData.fetchSkills(
      currentUserEmail
    );
    if (userSkillsData == null) {
      return res.status(404).json({ message: "no data found" });
    } else {
      return res.status(200).json({ data: userSkillsData });
    }
  } catch (error) {
    return res.status(404).json({ message: "No data available" });
  }
};

exports.updateUserSkills = async (req, res) => {
  try {
    const response = req.body;
    const currentUserEmail = req.user.userEmail;
    const userId = await currentUser(currentUserEmail);
    const data = await db.sequelize.query(
      "EXEC dbo.spusers_updateuserskills :userId, :primarySkills, :secondarySkills, :certifications",
      {
        replacements: {
          userId: userId,
          primarySkills: response.primarySkills,
          secondarySkills: response.secondarySkills,
          certifications: response.certifications,
        },
      }
    );
    return res.status(200).json({ message: "Data updated successfully" });
  } catch (error) {
    return res.status(404).json({ message: "No data updated" });
  }
};