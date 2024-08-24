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


extends LineEdit

#-----------------------------------------------------------------------
# This text edit is used to input data into some SkinData entry
#-----------------------------------------------------------------------

@onready var editor : MenuScreen = Data.menu.current_screen

@export var data : String = ""
@export_multiline var description : String = ""


func _ready() -> void:
	text_changed.connect(_txt_changed)
	mouse_entered.connect(_selected)


func _txt_changed(new_text : String) -> void:
	editor._edit_skn_text_data(data, new_text)


func _selected() -> void:
	editor._show_description(description)
