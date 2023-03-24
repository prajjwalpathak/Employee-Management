const db = require("../../models");
const currentUser = require("./currentUser");

const fetchSkills = async (userEmail) => {
  try {
    const userId = await currentUser(userEmail);
    const data = await db.sequelize.query(
      "EXEC dbo.spusers_getuserskills :userId",
      {
        replacements: { userId: userId },
      }
    );
    return data[0][0];
  } catch (error) {
    return error;
  }
};

module.exports = { fetchSkills };
