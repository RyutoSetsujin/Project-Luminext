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


extends UIElement

var hurry_up : bool = false
var hurry_up2 : bool = false


func _start() -> void:
	$Clock/ClockAnim.stop()
	$Clock/BeatAnim.stop()
	
	$Clock/ClockAnim.play("clock_start")
	$Clock/BeatAnim.play("circle_beat_start")
	await get_tree().create_timer(1.0).timeout
	$Clock/ClockAnim.play("clock")
	$Clock/BeatAnim.play("circle_beat")


func _stop() -> void:
	$Clock/ClockAnim.play("RESET")
	$Clock/BeatAnim.play("RESET")


func _set_time(time : float) -> void:
	$Time.text = str(ceil(time))
	var point : float = snapped(time,0.01) - int(time)
	if point > 0.0:
		$Time2.text = str(point).substr(1,3)
	else:
		$Time2.text = ".00"
	$Time3.text = str(ceil(time))
	
	if time < 100.0:
		$Time.label_settings.font_size = 96
		$Time.position = Vector2(1352, 201)
	elif time < 200.0:
		$Time.label_settings.font_size = 90
		$Time.position = Vector2(1351, 206)
	elif time < 1000.0:
		$Time.label_settings.font_size = 72
		$Time.position = Vector2(1348, 223)
	elif time < 2000.0:
		$Time.label_settings.font_size = 64
		$Time.position = Vector2(1346, 230)
	else:
		$Time.label_settings.font_size = 56
		$Time.position = Vector2(1345, 238)
	
	if time < 0.01:
		$Time.text = "0"
		$Time2.text = ".00"
		$Time3.text = "TIMEOUT"
		$Time3.label_settings.font_size = 128
	
	if time < 16 and not hurry_up:
		hurry_up = true
		var tween : Tween = create_tween().set_parallel(true)
		tween.tween_property($Clock,"modulate",Color("ffa61c"),1.0)
		tween.tween_property($Time,"modulate",Color("ffa61c"),1.0)
		tween.tween_property($Time2,"modulate",Color("ffa61c"),1.0)
		tween.tween_property($Time3,"modulate",Color("ffa61c80"),1.0)
	elif time < 4 and not hurry_up2:
		hurry_up2 = true
		var tween : Tween = create_tween().set_parallel(true)
		tween.tween_property($Clock,"modulate",Color("d02f2f"),1.0)
		tween.tween_property($Time,"modulate",Color("d02f2f"),1.0)
		tween.tween_property($Time2,"modulate",Color("d02f2f"),1.0)
		tween.tween_property($Time3,"modulate",Color("d02f2f80"),1.0)
	elif time > 16:
		hurry_up = false
		hurry_up2 = false
		$Clock.modulate = Color("ffffff80")
		$Time.modulate = Color.WHITE
		$Time2.modulate = Color.WHITE
		$Time3.modulate = Color("ffffff80")
		$Time3.label_settings.font_size = 196


func _set_score(value : int) -> void:
	$V/score.text = str(value)


func _set_hiscore(value : int) -> void:
	$V/hiscore.text = str(value)
