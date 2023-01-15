const axios = require('axios');
const functions = require('firebase-functions');
const timezone = 'Asia/Tokyo';
process.env.TZ = timezone;

getAuth()
  .getUser(uid)
  .then((userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log(`Successfully fetched user data: ${userRecord.toJSON()}`);
  })
  .catch((error) => {
    console.log('Error fetching user data:', error);
  });



const query_params = new URLSearchParams({ 
    appid: "985daafdbc6c68ae20ede36ee513bc9a",
    q: "Takizawa",
    units: "metric",
    lang:"ja",
});

exports.doGetWeather = functions.region('asia-northeast1').pubsub.schedule('every 1 minutes').timeZone(timezone).onRun(async(context) => {
    const response = await axios.get('https://api.openweathermap.org/data/2.5/weather?' + query_params);
    console.log('現在の滝沢市の気温は' + [response.data.main.temp]);
})