/*global Launcher, onInitLauncher, Promise, document, XMLHttpRequest, console, resolve, reject, confirm*/

onInitLauncher = function() {
	Launcher.getEpisodeInfo("launcher", "info.json", function(episodeData) {
		var keyboardMap = [
			"", // [0]
			"", // [1]
			"", // [2]
			"CNCL", // [3]
			"", // [4]
			"", // [5]
			"HELP", // [6]
			"", // [7]
			"BCKS", // [8]
			"TAB", // [9]
			"", // [10]
			"", // [11]
			"CLR", // [12]
			"ENTR", // [13]
			"ENTRS", // [14]
			"", // [15]
			"SHFT", // [16]
			"CTRL", // [17]
			"ALT", // [18]
			"PAUS", // [19]
			"CAPS", // [20]
			"KANA", // [21]
			"EISU", // [22]
			"JNJA", // [23]
			"FIN", // [24]
			"HNJA", // [25]
			"", // [26]
			"ESC", // [27]
			"CONV", // [28]
			"NONC", // [29]
			"ACC", // [30]
			"MODE", // [31]
			"SPACE", // [32]
			"PGUP", // [33]
			"PGDWN", // [34]
			"END", // [35]
			"HOME", // [36]
			"LEFT", // [37]
			"UP", // [38]
			"RIGHT", // [39]
			"DOWN", // [40]
			"SEL", // [41]
			"PRNT", // [42]
			"EXE", // [43]
			"PRNT", // [44]
			"INS", // [45]
			"DEL", // [46]
			"", // [47]
			"0", // [48]
			"1", // [49]
			"2", // [50]
			"3", // [51]
			"4", // [52]
			"5", // [53]
			"6", // [54]
			"7", // [55]
			"8", // [56]
			"9", // [57]
			":", // [58]
			";", // [59]
			"<", // [60]
			"=", // [61]
			">", // [62]
			"?", // [63]
			"@", // [64]
			"A", // [65]
			"B", // [66]
			"C", // [67]
			"D", // [68]
			"E", // [69]
			"F", // [70]
			"G", // [71]
			"H", // [72]
			"I", // [73]
			"J", // [74]
			"K", // [75]
			"L", // [76]
			"M", // [77]
			"N", // [78]
			"O", // [79]
			"P", // [80]
			"Q", // [81]
			"R", // [82]
			"S", // [83]
			"T", // [84]
			"U", // [85]
			"V", // [86]
			"W", // [87]
			"X", // [88]
			"Y", // [89]
			"Z", // [90]
			"OS", // [91] Windows Key (Windows) or Command Key (Mac)
			"", // [92]
			"MENU", // [93]
			"", // [94]
			"SLP", // [95]
			"0", // [96]
			"1", // [97]
			"2", // [98]
			"3", // [99]
			"4", // [100]
			"5", // [101]
			"6", // [102]
			"7", // [103]
			"8", // [104]
			"9", // [105]
			"*", // [106]
			"+", // [107]
			"SEP", // [108]
			"-", // [109]
			".", // [110]
			"/", // [111]
			"F1", // [112]
			"F2", // [113]
			"F3", // [114]
			"F4", // [115]
			"F5", // [116]
			"F6", // [117]
			"F7", // [118]
			"F8", // [119]
			"F9", // [120]
			"F10", // [121]
			"F11", // [122]
			"F12", // [123]
			"F13", // [124]
			"F14", // [125]
			"F15", // [126]
			"F16", // [127]
			"F17", // [128]
			"F18", // [129]
			"F19", // [130]
			"F20", // [131]
			"F21", // [132]
			"F22", // [133]
			"F23", // [134]
			"F24", // [135]
			"", // [136]
			"", // [137]
			"", // [138]
			"", // [139]
			"", // [140]
			"", // [141]
			"", // [142]
			"", // [143]
			"NUM", // [144]
			"SCROLL", // [145]
			"JISHO", // [146]
			"MASSHOU", // [147]
			"TOUROKU", // [148]
			"LOYA", // [149]
			"ROYA", // [150]
			"", // [151]
			"", // [152]
			"", // [153]
			"", // [154]
			"", // [155]
			"", // [156]
			"", // [157]
			"", // [158]
			"", // [159]
			"^", // [160]
			"!", // [161]
			"\"", // [162]
			"#", // [163]
			"$", // [164]
			"%", // [165]
			"&", // [166]
			"_", // [167]
			"(", // [168]
			")", // [169]
			"*", // [170]
			"+", // [171]
			"|", // [172]
			"-", // [173]
			"{", // [174]
			"}", // [175]
			"~", // [176]
			"", // [177]
			"", // [178]
			"", // [179]
			"", // [180]
			"MUTE", // [181]
			"VDOWN", // [182]
			"VUP", // [183]
			"", // [184]
			"", // [185]
			";", // [186]
			"=", // [187]
			",", // [188]
			"-", // [189]
			".", // [190]
			"/", // [191]
			"\'", // [192]
			"", // [193]
			"", // [194]
			"", // [195]
			"", // [196]
			"", // [197]
			"", // [198]
			"", // [199]
			"", // [200]
			"", // [201]
			"", // [202]
			"", // [203]
			"", // [204]
			"", // [205]
			"", // [206]
			"", // [207]
			"", // [208]
			"", // [209]
			"", // [210]
			"", // [211]
			"", // [212]
			"", // [213]
			"", // [214]
			"", // [215]
			"", // [216]
			"", // [217]
			"", // [218]
			"[", // [219]
			"\\", // [220]
			"]", // [221]
			"\'", // [222]
			"", // [223]
			"META", // [224]
			"ALTG", // [225]
			"", // [226]
			"HELP", // [227]
			"00", // [228]
			"", // [229]
			"CLEAR", // [230]
			"", // [231]
			"", // [232]
			"RESET", // [233]
			"JUMP", // [234]
			"PA1", // [235]
			"PA2", // [236]
			"PA3", // [237]
			"WCTRL", // [238]
			"CUSEL", // [239]
			"ATTN", // [240]
			"FIN", // [241]
			"COPY", // [242]
			"AUTO", // [243]
			"ENLW", // [244]
			"BTAB", // [245]
			"ATTN", // [246]
			"CRSEL", // [247]
			"EXSEL", // [248]
			"EREOF", // [249]
			"PLAY", // [250]
			"ZOOM", // [251]
			"", // [252]
			"PA1", // [253]
			"CLR", // [254]
			"" // [255]
		];
		var joystickCipher = {};
		joystickCipher["default"] = [0, 1, 2, 3, 4, 5, 10, 11, 6, 7, 8, 9];
		joystickCipher["Xbox 360 Controller (XInput STANDARD GAMEPAD)"] = [0, 1, 2, 3, 4, 5, 10, 11, 6, 7, 8, 9];
		function isSecondVersionNewer(a, b) {
			if (a === undefined || b === undefined) {
				return false;
			}
			var i = 0;
			while (true) {
				if (a[i] === undefined && b[i] === undefined) {
					return false;
				} // Ran out of digits, *not* newer
				if (b[i] === undefined) {
					return false;
				} // Equal so far and second is shorter, *not* newer
				if (a[i] === undefined) {
					return true;
				} // Equal so far and second is longer, newer
				if (b[i] > a[i]) {
					return true;
				} // Equal so far and second digit is higher, newer
				i = i + 1;
			}
			return false;
		}
		
		function showPosts() {
			var xhttp = new XMLHttpRequest();
			xhttp.onreadystatechange = function() {
				if (xhttp.readyState === 4 && xhttp.status === 200) {
					while (document.getElementById("rightColumn").firstChild) {
						document.getElementById("rightColumn").removeChild(document.getElementById("rightColumn").firstChild);
					}
					var parser = new DOMParser();
					var xmlDoc = parser.parseFromString(xhttp.responseText, "text/xml");
					var posts = document.createElement("div");
					var arrayOfItems = Array.from(xmlDoc.getElementsByTagName("item"));
					var expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
					var expression2 = /<p class="link-more">.*/gi;
					var expression3 = /View post on imgur.com/gi;
					var expression4 = /<img src="" \/>/gi;
					var expression5 = /<img.* \/>/gi;
					arrayOfItems.forEach(function(someItem) {
						postEntry = document.createElement("div");
						postEntry.setAttribute("class", "rssEntry");
						var somePostLink = document.createElement("a");
						somePostLink.setAttribute("href", someItem.querySelector("link").textContent);
						somePostLink.setAttribute("class", "rssLink");
						somePostLink.appendChild(document.createTextNode(someItem.querySelector("title").textContent));
						somePostDescriptionBox = document.createElement("div");
						somePostDescriptionBox.setAttribute("class", "descriptionBox");
						somePostDescription = document.createElement("div");
						somePostDescription.setAttribute("class", "rssDescription");
						if (someItem.querySelector("description")) {
							var someDescription = someItem.querySelector("description").textContent;
							var someNewParser = new DOMParser();
							var someImage = someNewParser.parseFromString(someDescription, "text/html").querySelector(".wp-post-image");
							if (someImage) {
								var entryThumbnailDiv = document.createElement("div");
								entryThumbnailDiv.setAttribute("class", "descriptionThumbnailDiv");
								var entryThumbnail = document.createElement("img");
								entryThumbnail.src = someImage.src;
								entryThumbnailDiv.appendChild(entryThumbnail);
								somePostDescriptionBox.appendChild(entryThumbnailDiv);
							}
							somePostDescription.innerHTML = someDescription.replace(expression3, "").replace(expression2, "").replace(expression, "").replace(expression4, "").replace(expression5, "").substring(0, 150) + "...";
						} else {
							somePostDescription.appendChild(document.createTextNode("No Description"));
						}
						postEntry.appendChild(somePostLink);
						somePostDescriptionBox.appendChild(somePostDescription);
						postEntry.appendChild(somePostDescriptionBox);
						posts.appendChild(postEntry);
					});
					
					document.getElementById("rightColumn").appendChild(posts);
				}
			};
			xhttp.open("GET", "http://codehaus.wohlsoft.ru/blog/feed/?" + (new Date()).getTime(), true);
			xhttp.send();
		}
		
		function parseIniString(data) {
			var regex = {
				section: /^\s*\[\s*([^\]]*)\s*\]\s*$/,
				param: /^\s*([^=]+?)\s*=\s*(.*?)\s*$/,
				comment: /^\s*;.*$/
			};
			var value = {};
			var lines = data.split(/[\r\n]+/);
			var section = null;
			var match;
			lines.forEach(function(line) {
				if (regex.comment.test(line)) {
					return;
				} else if (regex.param.test(line)) {
					match = line.match(regex.param);
					if (section) {
						value[section][match[1]] = match[2];
					} else {
						value[match[1]] = match[2];
					}
				} else if (regex.section.test(line)) {
					match = line.match(regex.section);
					value[match[1]] = {};
					section = match[1];
				} else if (line.length == 0 && section) {
					section = null;
				}
			});
			return value;
		}
		
		function getLocalFile(url) {
			return new Promise(function(resolve, reject) {
				var xhttp = new XMLHttpRequest();
				xhttp.onreadystatechange = function() {
					if (xhttp.readyState === 4 && xhttp.status === 0) {
						var response = xhttp.response;
						if (response.length > 0) {
							resolve(response);
						} else {
							reject(Error("I didn't find an achievements folder"));
						}
					}
				};
				xhttp.open("GET", url, true);
				xhttp.send();
			});
		}
		
		function addToAchievementCenter(someJsonObject, someParsedIniList, episode, episodeIdentifier) {
			var achievementCenterMasterBox = document.getElementById("achievementIcons");
			var achievementCenterListMasterBox = document.getElementById("achievementLists");
			var episodeEntry = document.createElement("div");
			episodeEntry.setAttribute("style", "achievementEpisodeIconEntry");
			episodeEntry.setAttribute("data-identifier", episodeIdentifier);
			var episodeIcon = document.createElement("div");
			episodeIcon.setAttribute("style", "achievementEpisodeIcon");
			var episodeIconImage = document.createElement("img");
			if (episode.episodeIcon) {
				episodeIconImage.setAttribute("src", "../worlds/" + episode.directoryName + "/launcher/" + episode.episodeIcon);
			} else {
				episodeIconImage.setAttribute("src", "default/icon.png");
			}
			episodeIcon.appendChild(episodeIconImage);
			episodeEntry.appendChild(episodeIcon);
			achievementCenterMasterBox.appendChild(episodeEntry);
			var episodeTitle = document.createElement("div");
			episodeTitle.setAttribute("class", "achievementEpisodeTitle");
			episodeTitle.appendChild(document.createTextNode(episode.title));
			episodeEntry.appendChild(episodeTitle);
			var theAchievementList = document.createElement("div");
			theAchievementList.setAttribute("class", "achievementList");
			theAchievementList.setAttribute("id", "entry" + episodeIdentifier);
			var numberOfAchievements = 0;
			for (var i = 0; i < someParsedIniList.length; i = i + 1) {
				var achievementEntry = document.createElement("div");
				achievementEntry.setAttribute("class", "individualAchievement");
				var achievementTitle = document.createElement("div");
				achievementTitle.setAttribute("class", "achievementTitle");
				achievementTitle.appendChild(document.createTextNode(someParsedIniList[i].name.substring(1, someParsedIniList[i].name.length-1)));
				achievementEntry.appendChild(achievementTitle);
				var achievementDescription = document.createElement("div");
				achievementDescription.setAttribute("class", "overallAchievementDescription");
				if (someParsedIniList[i].description) {
					var achievementDescriptionDiv = document.createElement("div");
					achievementDescriptionDiv.setAttribute("class", "achievementDescriptionDiv");
					achievementDescriptionDiv.appendChild(document.createTextNode(someParsedIniList[i].description.substring(1, someParsedIniList[i].description.length-1)));
					achievementDescription.appendChild(achievementDescriptionDiv);
				}
				var listOfKeys = Object.keys(someParsedIniList[i]);
				var listOfCompletableConditions = [];
				var listOfConditions = document.createElement("div");
				listOfConditions.setAttribute("class", "listOfConditions");
				listOfKeys.forEach(function(keyName) {
					if (keyName.match("condition-") && !keyName.match("desc")) {
						var toPush = {};
						toPush.conditionCounter = keyName.replace("condition-", "");
						if (someParsedIniList[i][keyName + "-desc"]) {
							var someConditionDescription = document.createElement("div");
							someConditionDescription.setAttribute("class", "conditionDescription");
							someConditionDescription.appendChild(document.createTextNode(someParsedIniList[i][keyName + "-desc"].substring(1, someParsedIniList[i][keyName + "-desc"].length - 1)));
							listOfConditions.appendChild(someConditionDescription);
						} else {
							toPush.conditionDescription = "???";
						}
						listOfCompletableConditions.push(toPush);
					}
				});
				achievementDescription.appendChild(listOfConditions);
				achievementEntry.appendChild(achievementDescription);
				theAchievementList.appendChild(achievementEntry);
			}
			achievementCenterListMasterBox.appendChild(theAchievementList);
			achievementCenterMasterBox.appendChild(episodeEntry);
		}
		
		function listInifiles(response) {
			var parser = new DOMParser();
			var htmlDoc = parser.parseFromString(response, "text/html");
			var listOfScripts = htmlDoc.getElementsByTagName("script");
			var finalList = [];
			for (i = 0; i < listOfScripts.length; i = i + 1) {
				if (listOfScripts[i].innerHTML.match("\\.ini")) {
					finalList.push(listOfScripts[i].innerHTML.split(",")[1].replace(/\"/gi, ""));
				}
			}
			return finalList;
		}
		
		function onOff(someElement) {
			if (someElement.style.display === "block") {
				someElement.style.display = "none";
			} else {
				someElement.style.display = "block";
			}
		}
		function toggleOther(toEnableId) {
			document.getElementById("middleColumn").querySelectorAll(":scope > div:not(.otherStuff), iframe").forEach(function(someDiv) {
				if (someDiv.id === toEnableId) {
					if (someDiv.style.display === "flex") {
						someDiv.style.display = "none";
						document.getElementById("iframer").style.display = "flex";
					} else {
						someDiv.style.display = "flex";
					}
				} else {
					someDiv.style.display = "none";
				}
			});
		}
		
		function manageBottomPanel(toActivate, toGray) {
			document.getElementById("controlSection").querySelectorAll(":scope > div").forEach(function(someDiv) {
				if (someDiv.id === toActivate) {
					someDiv.style.display = "flex";
				} else {
					someDiv.style.display = "none";
				}
			});
		}
		
		function selectEpisodeById(i) {
			var episode = episodeData[i];
			var iframe = document.getElementById("iframer");
			
			// Remove existing iframe load listeners
			if (iframeOnLoadHandler != null)
			{
				iframe.removeEventListener("load", iframeOnLoadHandler);
			}
			
			// Set iframe SRC
			if (episode.mainPage) {
				// If the episode defines a main page, use it
				iframe.src = "../worlds/" + episode.directoryName + "/launcher/" + episode.mainPage;
			} else {
				// Otherwise... Fun stuff!
				iframeOnLoadHandler = (function() {
					var doc = iframe.contentDocument;
					populateEpisodeTemplate(episode, doc);
				});
				iframe.addEventListener("load", iframeOnLoadHandler);
				iframe.src = "default/index.html";
			}
			
			// Set player selection
			var player1Label = document.getElementById("player1Label");
			var player2Label = document.getElementById("player2Label");
			player1Label.innerHTML = "";
			player2Label.innerHTML = "";
			var populatePlayerSelector = (function(containerObj, isPlayerTwo) {
				var selectObj = document.createElement("select");
				var optionObj;
				if (isPlayerTwo) {
					// If this is the player2 dropdown, add a None option
					optionObj = document.createElement("option");
					optionObj.value = "0";
					optionObj.textContent = "None";
					selectObj.appendChild(optionObj);
				}
				for (var idx = 0; idx < episode.allowedCharacters.length; idx++) {
					// Get character ID and character name
					var charId = episode.allowedCharacters[idx];
					var charName = episode.characterNames[charId-1];
					optionObj = document.createElement("option");
					optionObj.value = charId.toString();
					optionObj.textContent = charName;
					selectObj.appendChild(optionObj);
				}
				containerObj.appendChild(selectObj);
				return selectObj;
			});
			var butts = document.createElement("span");
			var butts2 = document.createElement("span");
			if (episode.allowTwoPlayer !== false) {
				butts.appendChild(document.createTextNode("Player 1:"));
				player1Label.appendChild(butts);
			} else {
				butts.appendChild(document.createTextNode("Character:"));
				player1Label.appendChild(butts);
			}
			player1Selector = populatePlayerSelector(player1Label, false);
			player1Label.style.display = "inline-block";
			if (episode.allowTwoPlayer !== false) {
				butts2.appendChild(document.createTextNode("Player 2: "));
				player2Label.appendChild(butts2);
				player2Selector = populatePlayerSelector(player2Label, true);
				player2Label.style.display = "inline-block";
			} else {
				player2Selector = null;
				player2Label.style.display = "none";
			}
			
			// Set save slot info
			Launcher.getSaveInfo(episode.directoryName, function(saveFileList) {
				var listOfSaveSlots = document.getElementById("saveButtons").querySelectorAll(".saveData");
				var listOfSaveButtons = document.getElementById("saveButtons").querySelectorAll(".saveButton");
				for (var idx2 = 0; idx2 < listOfSaveButtons.length; idx2 = idx2 + 1) {
					if (idx2 !== 0) {
						listOfSaveButtons[idx2].style.backgroundColor = "#3a677a";
						listOfSaveButtons[idx2].style.border = "none";
					} else {
						listOfSaveButtons[idx2].style.backgroundColor = "#128ac9";
						listOfSaveButtons[idx2].style.border = "2px solid #3a677a";
					}
				}
			
				document.getElementById("currentSave").value = 1;
				for (var idx = 0; idx < listOfSaveSlots.length; idx = idx + 1) {
					var saveFile = saveFileList[idx];
					var saveSlot = listOfSaveSlots[idx];
					var extraText = "New";
					if (saveFile.isPresent) {
						if (episode.stars > 0) {
							extraText = "(" + saveFile.starCount.toString() + "/" + episode.stars.toString() + " Stars)";
						} else {
							extraText = "(" + saveFile.starCount.toString() + " Stars)";
						}
					}
					saveSlot.textContent = extraText;
					saveSlot.nextSibling.nextSibling.onclick = function () {
						document.getElementById("currentSave").value = this.dataset.save;
						for (var idx2 = 0; idx2 < listOfSaveButtons.length; idx2 = idx2 + 1) {
							listOfSaveButtons[idx2].style.backgroundColor = "#3a677a";
							listOfSaveButtons[idx2].style.border = "none";
						}
						this.style.border = "2px solid #3a677a";
						this.style.backgroundColor = "#128ac9";
					};
				}
			
			});
			
			
			// Check for updates
			Launcher.checkEpisodeUpdate(episode.directoryName, "launcher", "info.json", function(updateData){
				if (updateData) {
					if (isSecondVersionNewer(episode["current-version"], updateData["current-version"])) {
						var updateMsg = updateData["update-message"];
						if (updateMsg === undefined)
						{
							updateMsg = "An update to \"" + episode.title + "\" is avaliable.";
						}
						alert(updateMsg);
						if (updateData["download-url"]) {
							var aBomb = document.createElement("a");
							aBomb.setAttribute("href", updateData["download-url"]);
							aBomb.click();
						}
					}
				}
			});
		}
		
		function launchSMBXIGuess() {
			var episode = episodeData[parseInt(document.getElementById("currentEpisode").value)];
			Launcher.Autostart.useAutostart = true;
			Launcher.Autostart.character1 = parseInt(player1Selector.value);
			if ((player2Selector === null) || (parseInt(player2Selector.value) == 0)) {
				Launcher.Autostart.singleplayer = true;
				Launcher.Autostart.character2 = parseInt(player1Selector.value);
			} else {
				Launcher.Autostart.singleplayer = false;
				Launcher.Autostart.character2 = parseInt(player2Selector.value);
			}
			Launcher.Autostart.saveSlot = parseInt(document.getElementById("currentSave").value);
			Launcher.Autostart.episodeName = episode.title;
			Launcher.runSMBX();
		}
		function populateEpisodeTemplate(episode, doc) {
			var titleField = doc.getElementById("titleField");
			var starsField = doc.getElementById("starsField");
			var starsContainer = doc.getElementById("starsContainer");
			var creditsField = doc.getElementById("creditsField");
			var creditsContainer = doc.getElementById("creditsContainer");
			
			if (titleField) titleField.textContent = episode.title;
			if (episode.stars && starsField) {
				if (starsContainer) starsContainer.style.display = "block";
				starsField.textContent = episode.stars.toString();
				if (episode.stars == 1) {
					starsField.textContent += " Star";
				} else if (episode.stars > 1) {
					starsField.textContent += " Stars";
				}
			}
			if (episode.credits && creditsField) {
				creditsField.innerHTML = "";
				if (creditsContainer) creditsContainer.style.display = "block";
				var lines = episode.credits.trim().split("\n");
				var tableObj = doc.createElement("table");
				tableObj.className = "creditsTable";
				for (var i = 0; i < lines.length; i++) {
					var line = lines[i].trim();
					var trObj = doc.createElement("tr");
					var lineSections = line.split(":");
					var tdObj;
					if (lineSections.length == 2) {
						tdObj = doc.createElement("th");
						tdObj.textContent = lineSections[0].trim() + ": ";
						trObj.appendChild(tdObj);
						tdObj = doc.createElement("td");
						tdObj.textContent = lineSections[1].trim();
						trObj.appendChild(tdObj);
					}
					else
					{
						tdObj = doc.createElement("td");
						tdObj.textContent = line;
						tdObj.colSpan = "2";
						trObj.appendChild(tdObj);
					}
					tableObj.appendChild(trObj);
				}
				creditsField.appendChild(tableObj);
			}
		}
		function areWeSettingAKeyboard() {
			if (document.getElementById("useJoystick").checked) {
				return "joystick";
			} else {
				return "keyboard";
			}
		}
		function assignKeyCodes() {
			document.getElementById("gameConfigTab").querySelectorAll("input:not([type=button]):not([type=checkbox]):not([type=radio])").forEach(function(someInput) {
				if (someInput.value !== "unset") {
					someInput.value = keyboardMap[someInput.value];
				}
			});
		}
		function populateControls() {
			var keyboardOrNot = areWeSettingAKeyboard();
			var setHidden;
			if (keyboardOrNot === "joystick") {
				setHidden = "none";
			} else {
				setHidden = "inline-block";
			}
			Array.from(document.getElementsByClassName("directionPad")).forEach(function(someDpad) {
				someDpad.style.display = setHidden;
			});
			document.getElementById("gameConfigTab").querySelectorAll("input:not([type=button]):not([type=checkbox]):not([type=radio])").forEach(function(someInput) {
				someInput.value = Launcher.Controls[keyboardOrNot + someInput.id + document.querySelector('input[name="playerSelector"]:checked').value];
			});
			if (!document.getElementById("useJoystick").checked) {
				assignKeyCodes();
			}
		}
		function reportOnGamepad() {
			var gp = navigator.getGamepads()[0];
			var buttonCount = 0;
			var toSet;
			console.log(gp.id);
			gp.buttons.forEach(function(someButton) {
				if (someButton.pressed) {
					if (joystickCipher[gp.id]) {
						toSet = joystickCipher[gp.id][buttonCount];
					} else {
						toSet = joystickCipher["default"][buttonCount];
					}
					document.activeElement.value = toSet;
					document.activeElement.dataset.keyCode = toSet;
				}
				buttonCount = buttonCount + 1;
			});
		}
		window.addEventListener("gamepadconnected", function( event ) {
			if (document.getElementById("gameConfigTab").style.display === "flex" && document.getElementById("useJoystick").checked) {
				repGP = window.setInterval(reportOnGamepad, 100);
			}
		});
		var iframeOnLoadHandler = null;
		var player1Selector = null;
		var player2Selector = null;
		var ulObj = document.createElement("ul");
		ulObj.id = "episodeUl";
		function populateEpisodeData(episodeData, i) {
			var episode = episodeData[i];
			var liObj, liSpan1, liSpan2, iconImage, lineBreak, starSpan, maxStarCount;
			
			//Let's get those achievements set up...
			
			getLocalFile("../worlds/" + episode.directoryName + "/achievements/").then(function(response) {
				var iniFileList = listInifiles(response);
				var iniFileData = [];
				var iniFileDataPromise = Promise.all(iniFileList.map(function(iniFilename) {
					return(getLocalFile("../worlds/" + episode.directoryName + "/achievements/" + iniFilename).catch(function(reason) {
						return null;
					}).then(function(response) {
						return parseIniString(response);
					}));
				}));
				var progressFilePromise = getLocalFile("../worlds/" + episode.directoryName + "/achievements/progress.json");
				Promise.all([iniFileDataPromise, progressFilePromise]).then(function (response) {
					var iniFileData = response[0].filter(v => v !== null );
					var progressFile = response[1];
					addToAchievementCenter(JSON.parse(progressFile), iniFileData, episode, i);
				});
			});
			Launcher.getSaveInfo(episode.directoryName, function(saveFileList) {
				if (episode["hidden"] !== true) {
					liObj = document.createElement("li");
					liObj.dataset.identifier = i;
					liSpan1 = document.createElement("span");
					iconImage = document.createElement("img");
					if (episode.episodeIcon) {
						iconImage.setAttribute("src", "../worlds/" + episode.directoryName + "/launcher/" + episode.episodeIcon);
					} else {
						iconImage.setAttribute("src", "default/icon.png");
					}
					liSpan1.appendChild(iconImage);
					liSpan1.setAttribute("class", "episodeIcons");
					liSpan2 = document.createElement("span");
					liSpan2.textContent = episode.title;
					liSpan2.setAttribute("class", "episodeNames");
					if (episode.stars > 0) {
						lineBreak = document.createElement("br");
						liSpan2.appendChild(lineBreak);
						liSpan2.appendChild(lineBreak.cloneNode());
						starText = starText + "/" + episode.stars.toString();
						var maxStars = 0;
						for (var idx = 0; idx < 3; idx = idx + 1) {
							var saveFile = saveFileList[idx];
							if (saveFile.isPresent) {
								if (maxStars < saveFile.starCount) {
									maxStars = saveFile.starCount;
								}
							}
						}
						starSpan = document.createElement("span");
						starSpan.setAttribute("class", "theLiteralWordStars");
						starSpan.textContent = "Stars: ";
						liSpan2.appendChild(starSpan);
						var starText = maxStars + "/" + episode.stars.toString();
						maxStarCount = document.createTextNode(starText);
						liSpan2.appendChild(maxStarCount);
					}
					liObj.appendChild(liSpan1);
					liObj.appendChild(liSpan2);
					liObj.onclick = function () {
						document.getElementById("currentEpisode").value = this.dataset.identifier;
						selectEpisodeById(this.dataset.identifier);
						document.getElementById("iframer").style.display = "block";
						document.getElementById("achievementCenter").style.display = "none";
						document.getElementById("gameConfigTab").style.display = "none";
						document.getElementById("currentSave").value = 1;
					};
					ulObj.appendChild(liObj);
				}
			});
		}
		
		
		for (var i = 0; i < episodeData.length; i = i + 1) {
			populateEpisodeData(episodeData, i);
		}
		document.getElementById("episodeInfo").appendChild(ulObj);
		selectEpisodeById(document.getElementById("currentEpisode").value);
		document.getElementById("playButton").onclick = function () {
			launchSMBXIGuess();
		};
		/*
		document.getElementById("classicEditorButton").onclick = function () {
			Launcher.runSMBXEditor();
		}
		*/
		document.getElementById("newEditorButton").onclick = function () {
			Launcher.runPGEEditor();
		};
		document.getElementById("deleteSaveSlot").onclick = function() {
			var episode = episodeData[parseInt(document.getElementById("currentEpisode").value)];
			var slot = parseInt(document.getElementById("currentSave").value);
			if (confirm("Are you sure you want to delete save slot " + slot.toString() + "?")) {
				Launcher.deleteSaveSlot(episode.directoryName, slot);
				selectEpisodeById(parseInt(document.getElementById("currentEpisode").value));
			}
		};
		document.getElementById("leftIcon").onclick = function () {
			onOff(document.getElementById("leftColumn"));
		};
		document.getElementById("rightIcon").onclick = function () {
			onOff(document.getElementById("rightColumn"));
		};
		document.getElementById("bugIcon").onclick = function () {
			var tempLink = document.createElement("a");
			tempLink.href = "http://codehaus.moe/";
			tempLink.click();
		};
		document.getElementById("trophyIcon").onclick = function () {
			toggleOther("achievementCenter");
		};
		document.getElementById("saveIcon").onclick = function () {
			manageBottomPanel("saveButtonsBox");
		};
		document.getElementById("playerIcon").onclick = function () {
			manageBottomPanel("playerButtons");
		};
		document.getElementById("homeIcon").onclick = function () {
			manageBottomPanel("playButtons");
		};
		document.getElementById("controllerIcon").onclick = function () {
			toggleOther("gameConfigTab");
		};
		document.getElementById("filterEpisodes").onkeyup = function () {
			var filter, ul, li, i;
			filter = this.value.toUpperCase();
			ul = document.getElementById("episodeUl");
			li = ul.getElementsByTagName("li");

			for (i = 0; i < li.length; i = i + 1) {
				if (li[i].textContent.toUpperCase().indexOf(filter) > -1) {
					li[i].style.display = "";
				} else {
					li[i].style.display = "none";
				}
			}
		};
		document.getElementById("gameConfigTab").querySelectorAll("input:not([type=button]):not([type=checkbox])").forEach(function(someInput) {
			someInput.onkeyup = function (event) {
				if (!document.getElementById("useJoystick").checked) {
					this.value = keyboardMap[event.keyCode];
					this.dataset.keyCode = event.keyCode;
				}
			}
		});
		document.getElementById("saveControls").onclick = function () {
			var keyboardOrNot = areWeSettingAKeyboard();
			Launcher.Controls["controllerType" + document.querySelector('input[name="playerSelector"]:checked').value] = Number(document.getElementById("useJoystick").checked);
			document.getElementById("gameConfigTab").querySelectorAll("input:not([type=button]):not([type=checkbox]):not([type=radio])").forEach(function(someInput) {
				if (someInput.value) {
					Launcher.Controls[keyboardOrNot + someInput.id + document.querySelector('input[name="playerSelector"]:checked').value] = someInput.dataset.keyCode;
				}
			});
			Launcher.Controls.write();
			alert("Controls Saved");
		};
		document.getElementById("otherOptions").querySelectorAll("input:not([type=button])").forEach(function(someClickerThing) {
			someClickerThing.onclick = function() {
				populateControls();
			}
		});
		if (Launcher.Controls.controllerType1 === 1) {
			document.getElementById("useJoystick").checked = "checked";
		}
		Launcher.Controls.read(function(success){
			if (!success) {
				var playerNumber = [1, 2]
				var keyDefaults = [{keyName: "Up", keyValue: 38}, {keyName: "Down", keyValue: 40}, {keyName: "Left", keyValue: 37}, {keyName: "Right", keyValue: 39}, {keyName: "Run", keyValue: 88, joyValue: 2}, {keyName: "Jump", keyValue: 90, joyValue: 0}, {keyName: "Drop", keyValue: 16, joyValue: 6}, {keyName: "Pause", keyValue: 27, joyValue: 7}, {keyName: "AltJump", keyValue: 65, joyValue: 1}, {keyName: "AltRun", keyValue: 83, joyValue: 3}]
				playerNumber.forEach(function(somePlayer) {
					keyDefaults.forEach(function(someKeyDefault) {
						if (someKeyDefault.joyValue) {
							Launcher.Controls["joystick" + someKeyDefault.keyName + somePlayer] = someKeyDefault.joyValue;
						}
						Launcher.Controls["keyboard" + someKeyDefault.keyName + somePlayer] = someKeyDefault.keyValue;
						console.log("keyboard" + someKeyDefault.keyName + somePlayer + "  is now   " + someKeyDefault.keyValue);
					});
				});
				Launcher.Controls.write();
			}
		});
		populateControls();
		//Handle right-hand-side panel RSS Content
		showPosts();
	});
};