
- New Developers:
	Create a new folder titled your name in the "res://★Developers/" Directory.
	Here you can test and iterate anything in the project without messing up the current game.
	
When you are done iterating, you can fit your assets wherever they need to be.

	-Audio

		All audio files go in the res://Audio directory.

		If the audio is specific, create a subfolder in res://Audio (e.g. res://Audio/Player, res://Audio/MainMenu, etc.).

	-Scripts

		All scripts go in there specific modules location ("res://Modules/Player/Scripts")

		Keep general utility scripts in res://Scripts.
		
		Global Scripts will be in "res://Scripts/Globals"

	-Scenes

		All new scenes go in the res://Scenes directory.

		Major game areas or menus should have their own subfolders (e.g. res://Scenes/Levels, res://Scenes/UI, res://Scenes/MainMenu).

		If a scene has specific assets tied to it (like unique textures or meshes), Put them in there own folder named after the scene they are tied to inside of "res://Modules/UI/Assets/" 

	-Other Assets
	
		Shaders: Place in res://Shaders. Group by type if necessary.

		Fonts: Place in res://Modules/UI/Assets/.
