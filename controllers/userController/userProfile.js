const db = require('../../models');
const getUserProfileData = require('../fetchData/userProfile');
const currentUser = require('../fetchData/currentUser');

exports.postUserProfile = async (req, res) => {
	try {
		const response = req.body;
		const currentUserEmail = req.user.userEmail;
		const userId = await currentUser(currentUserEmail);
		const data = await db.sequelize.query(
			'EXEC dbo.spusers_postuserprofile :userId, :image, :permanentAddress, :city, :state, :country, :emergencyPhone',
			{
				replacements: {
					userId: userId,
					image: response.image,
					permanentAddress: response.permanentAddress,
					city: response.city,
					state: response.state,
					country: response.country,
					emergencyPhone: response.emergencyPhone
				}
			}
		);
		if (data[1] != 0) {
			return res.status(201).json({ message: 'User profile created successfully' });
		} else {
			return res.status(200).json({ message: 'User profile already exists' });
		}
	} catch (error) {
		console.log(error);
		return res.status(500).json({ message: 'User profile creation failed' });
	}
};

exports.getUserProfile = async (req, res) => {
	try {
		const currentUserEmail = req.user.userEmail;
		const userProfileData = await getUserProfileData.fetchProfile(currentUserEmail);
		if (userProfileData.length == 0) {
			return res.status(404).json({ message: 'No user profile found' });
		} else {
			return res.status(200).json({ data: userProfileData });
		}
	} catch (error) {
		console.log(error);
		return res.status(500).json({ message: 'User profile fetching failed' });
	}
};

exports.updateUserProfile = async (req, res) => {
	try {
		const response = req.body;
		const currentUserEmail = req.user.userEmail;
		const userId = await currentUser(currentUserEmail);
		const data = await db.sequelize.query(
			'EXEC dbo.spusers_updateuserprofile :userId, :image, :permanentAddress, :city, :state, :country, :emergencyPhone',
			{
				replacements: {
					userId: userId,
					image: response.image,
					permanentAddress: response.permanentAddress,
					city: response.city,
					state: response.state,
					country: response.country,
					emergencyPhone: response.emergencyPhone
				}
			}
		);
		return res.status(201).json({ message: 'User profile updated successfully' });
	} catch (error) {
		console.log(error);
		return res.status(500).json({ message: 'User profile updation failed' });
	}
};
