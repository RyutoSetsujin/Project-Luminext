# Project Luminext - an advanced open-source Lumines spiritual successor
# Copyright (C) <2024> <unfavorable_enhancer>
# Contact : <random.likes.apes@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


extends MenuScreen

const REGULAR_BUTTON : PackedScene = preload("res://menu/objects/regular_button.tscn")

var play_infinitely : bool = false
var use_precise_bpm_calculation : bool = false

var visualiser : int = 0
var color_scheme : int = 0
var sound_set : int = 0


func _ready() -> void:
	Data.menu.screens["background"]._change_gradient_colors(Color("340846"),Color("38303e"),Color("19013f"),Color("101010"),Color("020106"))
	cursor_selection_success.connect(_scroll)
	
	if not Data.menu.is_music_playing:
		Data.menu._change_music("menu_theme")
		if Data.menu.custom_data.has("last_music_pos"):
			Data.menu.music_player.seek(Data.menu.custom_data["last_music_pos"])
	
	_select_visualizer(Data.profile.config["misc"]["SY_visualizer"])
	_select_soundset(Data.profile.config["misc"]["SY_soundset"])

	$Menu/PlayInfinite._set_toggle_by_data(Data.profile.config)
	$Menu/PreciseCalc._set_toggle_by_data(Data.profile.config)

	_display_dir(OS.get_system_dir(OS.SYSTEM_DIR_MUSIC))


func _scroll(cursor_pos : Vector2) -> void:
	if Data.current_input_mode == Data.INPUT_MODE.MOUSE: return

	# Scroll music list
	if cursor_pos.x == 0: 
		$Music/List.scroll_vertical = clamp(currently_selected.position.y - 288 ,0 ,INF)


func _select_visualizer(value : float) -> void:
	$Menu/Visual/Slider2.value = value
	Data.profile.config["misc"]["SY_visualizer"] = value
	
	match int(value):
		SynthesiaMode.VISUALISER.SHOCKWAVE: 
			$Menu/Visual/Value.text = tr("SHOCKWAVE_FANCY")
			$Menu/Visual/Slider2.description = tr("SHOCKWAVE_FANCY_DESC")
			$Desc/Desc.text = tr("SHOCKWAVE_FANCY_DESC")
		SynthesiaMode.VISUALISER.SHOCKWAVE_SIMPLE: 
			$Menu/Visual/Value.text = tr("SHOCKWAVE_SIMPLE")
			$Menu/Visual/Slider2.description = tr("SHOCKWAVE_SIMPLE_DESC")
			$Desc/Desc.text = tr("SHOCKWAVE_SIMPLE_DESC")
		SynthesiaMode.VISUALISER.REZ: 
			$Menu/Visual/Value.text = tr("EDEN")
			$Menu/Visual/Slider2.description = tr("EDEN_DESC")
			$Desc/Desc.text = tr("EDEN_DESC")


func _select_soundset(value : float) -> void:
	$Menu/Soundset/Slider.value = value
	Data.profile.config["misc"]["SY_soundset"] = value

	match int(value):
		SynthesiaMode.SOUND_SET.DRUMS : 
			$Menu/Soundset/Value.text = tr("DRUMS")
			$Menu/Soundset/Slider.description = tr("DRUMS_DESC")
			$Desc/Desc.text = tr("DRUMS_DESC")
		SynthesiaMode.SOUND_SET.BFXR : 
			$Menu/Soundset/Value.text = tr("RETRO")
			$Menu/Soundset/Slider.description = tr("RETRO_DESC")
			$Desc/Desc.text = tr("RETRO_DESC")
		SynthesiaMode.SOUND_SET.CALM : 
			$Menu/Soundset/Value.text = "CALM"
			$Menu/Soundset/Slider.description = "Sound set featuring calm and chill samples."
			$Desc/Desc.text = "Sound set featuring calm and chill samples."
		SynthesiaMode.SOUND_SET.TECHNO : 
			$Menu/Soundset/Value.text = "TECHNO"
			$Menu/Soundset/Slider.description = "Sound set featuring some sick electronic samples."
			$Desc/Desc.text = "Sound set featuring some sick electronic samples."


func _display_dir(dir_path : String) -> void:
	for i : Node in $Music/List/V.get_children():
		i.queue_free()

	if dir_path != OS.get_system_dir(OS.SYSTEM_DIR_MUSIC):
		var button : MenuSelectableButton = REGULAR_BUTTON.instantiate()
		button.custom_minimum_size = Vector2(960, 48)
		button.work_mode = MenuSelectableButton.WORK_MODE.CALL
		button.description_node = null
		button.menu_position = Vector2(0,0)
		button.glow_color = Color("909090")
		button.description = "BACK_DIR"
		button.description_node = $Desc/Desc
		button.button_layout = 2
		button.call_function_name = "_display_dir"
		button.call_string = dir_path.erase(dir_path.rfind('/'), 999)
		button.text = ".. " + tr("BACK") + " .."
		$Music/List/V.add_child(button)

	var dir : DirAccess = DirAccess.open(dir_path)

	if dir:
		var y_pos : int = 1

		dir.list_dir_begin()
		var file_name : String = dir.get_next()

		while file_name != "":
			var button : MenuSelectableButton = REGULAR_BUTTON.instantiate()
			button.custom_minimum_size = Vector2(960, 48)
			button.work_mode = MenuSelectableButton.WORK_MODE.CALL
			button.description_node = null
			button.menu_position = Vector2i(0,y_pos)

			if dir.current_is_dir():
				button.glow_color = Color("a78923")
				button.description = "ENTER_DIR"
				button.description_node = $Desc/Desc
				button.call_function_name = "_display_dir"
				button.press_sound_name = "confirm3"
				button.button_layout = 2
				button.call_string = dir_path + "/" + file_name
				button.text = file_name
			else:
				if not file_name.get_extension() in ["mp3","ogg","wav"]: 
					file_name = dir.get_next()
					button.free()
					continue

				button.glow_color = Color("64cacc")
				button.description = "ENTER_PLAY"
				button.description_node = $Desc/Desc
				button.button_layout = 10
				button.call_function_name = "_start_game"
				button.call_string = dir_path + "/" + file_name
				button.text = file_name
			
			$Music/List/V.add_child(button)
			y_pos += 1
			file_name = dir.get_next()
		
		if y_pos > 1: 
			$Music/Help.visible = false
			$Music/Help2.visible = false
	else:
		print("DIR ACCESS ERROR")
		_display_dir(OS.get_system_dir(OS.SYSTEM_DIR_MUSIC))
	
	$Music/Dir.text = dir_path
	cursor = Vector2(0,0)
	_move_cursor()


func _exit_tree() -> void:
	Data.profile._save_config()


func _start_game(song_path : String) -> void:
	if Data.menu.is_music_playing:
		Data.menu.custom_data["last_music_pos"] = Data.menu.music_player.get_playback_position()
	
	var gamemode : Gamemode = SynthesiaMode.new()
	gamemode.music_file_path_to_load = song_path
	gamemode.is_single_run = !Data.profile.config["misc"]["SY_endless_song"]
	gamemode.use_precise_bpm_calculation = Data.profile.config["misc"]["SY_precise_bpm"]

	gamemode.visualiser = Data.profile.config["misc"]["SY_visualizer"]
	gamemode.sound_set = Data.profile.config["misc"]["SY_soundset"]
	
	var metadata : SkinMetadata = SkinMetadata.new()
	metadata.path = Data.BUILD_IN_PATH + Data.SKINS_PATH + "synthesia.skn"
	
	Data.menu._sound("enter")
	Data.main._start_game(metadata, gamemode)
