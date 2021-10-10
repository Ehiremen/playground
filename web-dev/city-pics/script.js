
const images = {
  IL: ['images/chicago.webp', 'Chicago, USA'],
  CN: ['images/china.webp', 'China'],
  FR: ['images/france.webp', 'France'],
  NJ: ['images/jersey city.webp', 'Jersey City, New Jersey, USA'],
  KR: ['images/karakura town.jpg', 'Karakura Town, Bleach Universe'],
  LA: ['images/los angeles.webp', 'Los Angeles, California, USA'],
  SP: ['images/saint paul.webp', 'Saint Paul'],
  TH: ['images/thailand.webp', 'Thailand'],
  JP: ['images/tokyo.webp', 'Tokyo, Japan'],
  CA: ['images/toronto.webp', 'Toronto, Canada'],
};

function makeCityWheel() {
  const cityController = new wheelnav("city-picker");
  cityController.wheelRadius = 200;
  cityController.centerX = 180;
  cityController.centerY = 180;
  cityController.spreaderInTitle = 'VISIT';
  cityController.spreaderOutTitle = 'CLOSE';
  cityController.spreaderTitleFont = '100 28px Helvetica';
  cityController.spreaderInPercent = 0.8;
  cityController.spreaderOutPercent = 1.1;
  cityController.colors = colorpalette.hotaru;
  cityController.spreaderEnable = true;
  cityController.spreaderRadius = 75;
  cityController.slicePathFunction = slicePath().MenuSliceWithoutLine;
  cityController.markerPathFunction = markerPath().MenuMarker;
  cityController.markerEnable = true;
  cityController.clickModeRotate = true;
  cityController.createWheel(Object.keys(images));
  return cityController;
}

const updateLabel = function (city) {
  const label = document.getElementsByClassName('label');
  if (city in images) {
    label[0].innerText = `${city} // ${images[city][1]}`;
  }
  else {
    label[0].innerText = '';
  }
}

const screenImg = document.querySelector('#screen img');
function imageSwitcher(city) {
  if (city in images) {
    screenImg.src = images[city][0];
    updateLabel(city);
  }
}

const cityController = makeCityWheel();
const cityElements = cityController.navItems;
for (c of cityElements) {
  let showCity = c.title;
  //the wheelNav SVG implements its own event listener as below
  // really thought the wheelNav was cool, so I decided to stick with this
  c.navigateFunction = function () { imageSwitcher(showCity); };
}

// event listener for bottom div
document.querySelector('#random-city').addEventListener('click', function() {
  const randCity = cityElements[Math.floor(Math.random() * cityElements.length)];
  imageSwitcher(randCity.title);
})
// Stretch 
// Make 1 div that when clicked will reveal a random city from your images data structure 