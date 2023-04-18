const userCheckInEvent = require("./checkin");
const userCheckOutEvent = require("./checkout");

const authorize = require("./authorize");
const { updateUserTimeDifference, getTimeDifference } = require("./message");
const currentUser = require("../controllers/fetchData/currentUser");
const {
  fetchCurrentAttendance,
} = require("../controllers/fetchData/userAttendance");

const onConnection = (io) => async (socket) => {
  try {
    await authorize(socket, async () => {
      console.log("Client connected: " + socket.id);
      const email = socket.user?.userEmail;
      // const userId = await currentUser(email);
      const date = new Date().toISOString().slice(0, 10); // 2021-05-05
      fetchCurrentAttendance(email, date).then(async (data) => {
        // timer for checkin
        const interval_id = setInterval(async () => {
          const data_ = await fetchCurrentAttendance(email, date);
          const status_ = data_[0]?.status || "not-checked-in";
          if (status_ === "checked-out") {
            clearInterval(interval_id);
            socket.disconnect();
            return;
          }
          const timeDifference = getTimeDifference(
            data_[0]?.checkInTime,
            data_[0]?.checkInDate
          );
          socket.emit("status", {
            status: status_,
            timeDifference: timeDifference,
          });
       
        }, 1000);

        socket.timerConnect = interval_id;
      });
    });
  } catch (error) {
    socket.emit("error", error);
  }
  socket.on("checkin", (data) => userCheckInEvent(data, socket));
  socket.on("checkout", (data) => userCheckOutEvent(data, socket));
  socket.on("disconnect", () => {
    clearInterval(socket?.timer);
    clearInterval(socket?.timerConnect);
    console.log("Client disconnected");
  });
};

module.exports = { onConnection };