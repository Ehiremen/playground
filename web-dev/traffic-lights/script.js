// let startOfAutoCycle = true;
autoLights(); // activate the auto system

document.getElementById("button").addEventListener("click", function () {
	toggleMode();
});

function resetLights() {
	document.querySelectorAll(".light").forEach((light) => {
		light.style.removeProperty("background-color");
	});
}

function getMode() {
	// returns true if manual
	return (
		document.getElementsByClassName("label")[0].innerText.toLowerCase() ===
		"manual"
	);
}

function toggleMode() {
	resetLights();
	// startOfAutoCycle = !startOfAutoCycle;
	const isManual = getMode();
	if (isManual) {
		document
			.querySelectorAll(".light")
			.forEach((light) =>
				light.removeEventListener("click", toggleLightEvent),
			);
		autoLights();
	} else {
		document
			.querySelectorAll(".light")
			.forEach((light) =>
				light.addEventListener("click", toggleLightEvent),
			);
	}
	document.getElementsByClassName("label")[0].innerText = isManual
		? "Automatic"
		: "Manual";
}

function toggleLight(id) {
	const element = document.getElementById(id);
	if (element.style.backgroundColor) {
		element.style.removeProperty("background-color");
	} else {
		resetLights();
		element.style.setProperty("background-color", id);
	}
}

function toggleLightEvent(event) {
	const id = event.target.id;
	toggleLight(id);
}

function cycleLights() {
	resetLights();
	setTimeout(function () {
		if (getMode()) return;
		toggleLight("red");
	}, 0);
	setTimeout(function () {
		if (getMode()) return;
		toggleLight("yellow");
	}, 2500);
	setTimeout(function () {
		if (getMode()) return;
		toggleLight("green");
	}, 4000);
	setTimeout(function () {
		if (getMode()) return;
		toggleLight("yellow");
	}, 7000);
}

function autoLights() {
	toggleLight("red");
	setInterval(cycleLights, 7500);
}
