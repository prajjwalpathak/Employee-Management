require("dotenv").config();
const { Sequelize, DataTypes } = require("sequelize");

const sequelize = new Sequelize(
  process.env.DATABASE,
  process.env.DB_USERNAME,
  process.env.DB_PASSWORD,
  {
    host: "localhost",
    logging: false,
    dialect: "mysql",
  }
);

try {
  sequelize.authenticate();
} catch (e) {
  console.log(e);
}

db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.user = require("./user")(sequelize, DataTypes);
db.userProfile = require("./userProfile")(sequelize, DataTypes);
db.userSkills = require("./userSkills")(sequelize, DataTypes);
db.userRequest = require("./userRequest")(sequelize, DataTypes);
db.userAttendance = require("./userAttendance")(sequelize, DataTypes);
db.userTimesheet = require("./userTimesheet")(sequelize, DataTypes);
db.userProjectList = require("./userProjectList")(sequelize, DataTypes);

db.user.hasOne(db.userProfile, {
  foreignKey: "userId",
  as: "userProfile",
});

db.userProfile.belongsTo(db.user, {
  foreignKey: "userId",
  as: "user",
});

db.user.hasOne(db.userSkills, {
  foreignKey: "userId",
  as: "userSkills",
});

db.userSkills.belongsTo(db.user, {
  foreignKey: "userId",
  as: "user",
});

db.user.hasOne(db.userRequest, {
  foreignKey: "userId",
  as: "userRequest",
});

db.userRequest.belongsTo(db.user, {
  foreignKey: "userId",
  as: "user",
});

db.user.hasOne(db.userAttendance, {
  foreignKey: "userId",
  as: "userAttendance",
});

db.userAttendance.belongsTo(db.user, {
  foreignKey: "userId",
  as: "user",
});

db.user.hasOne(db.userTimesheet, {
  foreignKey: "userId",
  as: "userTimesheet",
});

db.userTimesheet.belongsTo(db.user, {
  foreignKey: "userId",
  as: "userTimesheet",
});

db.user.hasOne(db.userProjectList, {
  foreignKey: "userId",
  as: "userProjectList",
});

db.userProjectList.belongsTo(db.user, {
  foreignKey: "userId",
  as: "userProjectList",
});

db.sequelize.sync({ force: false });

module.exports = db;