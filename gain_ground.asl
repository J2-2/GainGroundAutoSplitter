/*       
_______________________________________________________________________________________________________
|                                                                                                     |
| LiveSplit Auto Splitter script for Gain Ground (SEGA Mega Drive/Genesis Version).                   |
| Supported Emulators:                                                                                |
|   - Kega Fusion v3.64                                                                               |                                                                               |
|                                                                                                     |
| Made by J2_2:                                                                                       |                                                       |
|   - GitHub: https://github.com/Devilquest/LiveSplit-AutoSplitters                                   |
|_____________________________________________________________________________________________________|

*/

state("Fusion")
{
	ushort ggTime 		: 0x2A52D4, 0xA204;
    byte ggOut 			: 0x2A52D4, 0xA865;
	byte ggMenu 		: 0x1A1404;
	byte ggLoad			: 0x1A13C4;
	byte ggDifficulty	: 0x2A52D4, 0xF001;
}

startup
{
	// choose which difficulties the timer will start with so you don't forget to change it
	settings.Add("easy", true, "Easy Difficulty");
	settings.Add("normal", true, "Normal Difficulty");
    settings.Add("hard", true, "Hard Difficulty");
}

init
{
    refreshRate = 30;

    vars.currentLevel = 50;
    vars.split = false;
	vars.firstFalse = false;
}

update
{
	bool isLastLevel = vars.currentLevel == 50 || (vars.currentLevel == 40 && current.ggDifficulty == 0x00);
	if ((current.ggOut == 0x00 && old.ggOut != 0x00 && !isLastLevel) || (current.ggOut == 0x20 && isLastLevel))
    {
		vars.split = true;
    } 
}

start
{
    if(current.ggLoad != 0x00 && old.ggLoad == 0x00 && old.ggMenu == 0xA0 && ((settings["easy"] && old.ggDifficulty == 0x00) || (settings["normal"] && old.ggDifficulty == 0x01) || (settings["hard"] && old.ggDifficulty == 0x02)))
	{
        vars.currentLevel = 1;
		vars.firstLoad = true;
        return true;
    }
}

split
{
    if(vars.split)
    {
		vars.currentLevel = vars.currentLevel + 1;
        vars.split = false;
        return true;
    }
}

reset
{
    return current.ggTime == 0x0000 && old.ggTime != 0x0000;
}