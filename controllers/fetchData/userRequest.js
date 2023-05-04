const db = require("../../models");
const currentUser = require("./currentUser");

const fetchRequests = async (userEmail) => {
    try {
        const userId = await currentUser(userEmail);
        const userRequestsData = await db.sequelize.query(
            "EXEC dbo.spusers_getuserrequests :userId",
            {
                replacements: { userId: userId },
            }
        );
        return userRequestsData[0];
    } catch (error) {
        console.log(error);
        return error;
    }
};

const fetchSubordinatesRequests = async (userEmail) => {
    try {
        const currentUser = await db.sequelize.query(
            "EXEC dbo.spusers_getcurrentuser :email",
            {
                replacements: { email: userEmail },
            }
        );
        const currentUserHrmId = currentUser[0][0].hrmid;
        const subordinateRequetsData = await db.sequelize.query(
            "EXEC dbo.spusers_getusersubordinatesrequests :hrmid",
            {
                replacements: {
                    hrmid: currentUserHrmId,
                },
            }
        );
        return subordinateRequetsData[0];
    } catch (error) {
        console.log(error);
        return error;
    }
};

const fetchCurrentRequest = async (userId, requestId) => {
	try {
		const userRequestData = await db.sequelize.query(
			'EXEC dbo.spusers_getusercurrentrequest :userId, :id',
			{
				replacements: { userId: userId, id: requestId }
			}
		);
		return userRequestData[0];
	} catch (error) {
		console.log(error);
		return error;
	}
};

module.exports = { fetchRequests, fetchCurrentRequest, fetchSubordinatesRequests };
