const images = {
	ch1: "images/blue-planet.jpg",
	ch2: "images/deadpool.jpg",
	ch3: "images/gravity.jpg",
	ch4: "images/good-will-hunting.jpg",
	ch5: "images/cnn.jpg",
	ch6: "images/koyaanisqatsi.jpg",
	ch7: "images/parts-unknown.jpg",
	ch8: "images/star-wars-solo.jpg",
};

const screenImg = document.querySelector("#screen img");
console.log(screenImg);
function imageSwitcher(channel) {
	if (channel in images) {
		screenImg.src = images[channel];
	}
}

/*
  // alt method
  const screen = document.querySelector('#screen')
  document.querySelector('.remote').addEventListener('click', function(event){
    const channel = event.target.id
    if(channel) screen.style.backgroundImage = `url(${images[channel]})`
  })
  */
const channelElements = document.getElementsByClassName("channel");

// Attach each event handlers to each channel
// Hints:
// - Again, you'll have to do this eight times
for (ch of channelElements) {
	let myID = ch.id;
	ch.addEventListener("click", function () {
		imageSwitcher(myID);
	});
}
