let changeColor = document.getElementById("changeColor");

// rome-ignore lint/js/noUndeclaredVariables
chrome.storage.sync.get(
	"color",
	({color}) => {
		changeColor.style.backgroundColor = color;
	},
);
