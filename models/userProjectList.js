module.exports = (sequelize, DataTypes) => {
  const USERPROJECTLIST = sequelize.define("userProjectList", {
    userId: {
      type: DataTypes.INTEGER,
    },
    projectId: {
      type: DataTypes.INTEGER,
    },
    projectName: {
      type: DataTypes.STRING,
    },
    date: {
      type: DataTypes.DATEONLY,
    },
    department: {
      type: DataTypes.STRING,
    },
  });
  return USERPROJECTLIST;
};
