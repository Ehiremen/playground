/*----- constants -----*/
const cells = document.querySelectorAll(".cell");
const resetButton = document.getElementById("button");
const winningCombos = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
	[0, 3, 6],
	[1, 4, 7],
	[2, 5, 8],
	[0, 4, 8],
	[2, 4, 6],
];

class Board {
	constructor() {
		(this.playerXTurn = true), // X=> true, O=> false
			(this.boardArray = Array.from({ length: 9 }, (v) => 0));
		this.winner = "A Tie";
	}
}

/*----- app's state (variables) -----*/
let gameBoard = new Board();

/*----- event listeners -----*/
cells.forEach((cell) => cell.addEventListener("click", cellClickListener));
button.addEventListener("click", reset);

/*----- functions -----*/
function cellClickListener(event) {
	const boxId = event.target.id;
	const markAs = gameBoard.playerXTurn ? "X" : "O";

	const cellNum = boxId.slice(-1) - 1;
	gameBoard.boardArray[cellNum] = gameBoard.playerXTurn ? 1 : -1;

	const boxIdElement = document.getElementById(boxId);
	boxIdElement.textContent = markAs; // populate div's text
	boxIdElement.removeEventListener("click", cellClickListener);
	boxIdElement.classList.add("disabled");
	document.getElementsByClassName("player-turn")[0].innerText =
		markAs === "X" ? "O" : "X";
	handleMoveLogic();
}

function reset() {
	cells.forEach((cell) => {
		document.getElementById(cell.id).textContent = "";
		document.getElementById(cell.id).classList.remove("disabled");
		cell.addEventListener("click", cellClickListener);
	});

	document.getElementsByClassName("player-turn")[0].innerText = "X";

	gameBoard = new Board();
	document.getElementById("winner-label").childNodes[0]["data"] = "";
}

function whichWinner() {
	gameBoard.winner = gameBoard.playerXTurn ? "Team X" : "Team O";
}

function comboDidWork(combo) {
	const boardCopy = gameBoard.boardArray;
	const compElement = boardCopy[combo[0]];
	if (compElement === 0) {
		return false;
	}

	return combo.every((val) => boardCopy[val] === compElement);
}

function isGameOver() {
	const board = gameBoard.boardArray;
	if (winningCombos.some(comboDidWork)) {
		whichWinner();
		return true;
	}

	// if all boxes are filled, return true to signify tie
	return gameBoard.boardArray.every((val) => val != 0);
}

function announceWinner() {
	document.getElementById("winner-label").childNodes[0][
		"data"
	] = `Winner is: ${gameBoard.winner}!!!`;
}

function handleMoveLogic() {
	if (isGameOver()) {
		cells.forEach((cell) =>
			cell.removeEventListener("click", cellClickListener),
		);
		announceWinner();
	} else {
		gameBoard.playerXTurn = !gameBoard.playerXTurn;
	}
}
