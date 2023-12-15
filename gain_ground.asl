/*       
_______________________________________________________________________________________________________
|                                                                                                     |
| LiveSplit Auto Splitter script for Gain Ground (SEGA Mega Drive/Genesis Version).                   |
| Supported Emulators:                                                                                |
|   - Kega Fusion v3.64                                                                               |                                                                               |
|                                                                                                     |
| Made by J2_2:                                                                                       |                                                       |
|   - GitHub: https://github.com/J2-2/GainGroundAutoSplitter                                 		  |
|_____________________________________________________________________________________________________|

*/

state("Fusion")
{
	byte ggLevel		: 0x2A52D4, 0xA29F;
	byte ggDifficulty	: 0x2A52D4, 0xF001;
	ushort ggTime		: 0x2A52D4, 0xA204;
	byte ggMenu		: 0x1A1404;
	byte ggLoad		: 0x1A13C4;
}

startup
{
	settings.Add("easy", true, "Start Splits on Easy Difficulty");
	settings.Add("normal", true, "Start Splits on Normal Difficulty");
	settings.Add("hard", true, "Start Splits on Hard Difficulty");
	settings.Add("rounds", false, "Only Split on Round End");
}

init
{
	refreshRate = 30;
	vars.currentLevel = 1;
	vars.split = false;
}

update
{
	print("currentLevel: " + (vars.currentLevel) + ", ggLevel: " + current.ggLevel);
	if (current.ggLevel == vars.currentLevel)
	{
		vars.split = true;
	} 
}

start
{
	if(current.ggLoad != 0x00 && old.ggLoad == 0x00 && old.ggMenu == 0xA0 && ((settings["easy"] && old.ggDifficulty == 0x00) || (settings["normal"] && old.ggDifficulty == 0x01) || (settings["hard"] && old.ggDifficulty == 0x02)))
	{
		vars.currentLevel = 1;
		return true;
	}
}

split
{
	if(vars.split)
	{
		vars.currentLevel += 1;
		if (vars.currentLevel == 31 && current.ggDifficulty == 0x00) {
			vars.currentLevel = 41;
		}
		vars.split = false;
		return !settings["rounds"] || vars.currentLevel % 10 == 1;
	}
}

reset
{
	return current.ggTime == 0x0000 && old.ggTime != 0x0000;
}
