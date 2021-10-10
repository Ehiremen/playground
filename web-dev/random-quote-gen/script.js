const quoteContainer = document.getElementById("quote-container");
const quoteText = document.getElementById("quote");
const authorText = document.getElementById("author");
const twitterBtn = document.getElementById("twitter");
const newQuoteBtn = document.getElementById("new-quote");

async function getQuote() {
	const apiUrl =
		"http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en";
	const proxyUrl = "https://shrouded-inlet-14671.herokuapp.com/";

	try {
		const response = await fetch(proxyUrl + apiUrl);
		const data = await response.json();

		authorText.innerText = data.quoteAuthor || "unknown";
		quoteText.innerText = data.quoteText;
		console.log(data);
	} catch (error) {
		console.log(error.message);
		getQuote();
	}
}

function tweetQuote() {
	const quote = quoteText.innerText;
	const author = authorText.innerText;
	const twitterUrl = `https://twitter.com/intent/tweet?text=${quote} - ${author}`;
	window.open(twitterUrl, "_blank");
}

// event listeners
newQuoteBtn.addEventListener("click", getQuote);
twitterBtn.addEventListener("click", tweetQuote);

// on load
getQuote();
