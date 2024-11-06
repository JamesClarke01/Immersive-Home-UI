extends Node3D

const Notification = preload ("res://addons/immersive-home-ui/content/ui/components/notification/notification.tscn")

@onready var animation_player = $AnimationPlayer
@onready var open_sound = $OpenSound
@onready var close_sound = $CloseSound
@onready var notify_place = $AnimationContainer/NotifyPlace

var show_menu = R.state(false)

func _ready():
	App.main.remove_child.call_deferred(self)

	R.effect(func(_arg):
		if show_menu.value:
			App.main.add_child(self)
			move_into_view()
			animation_player.play_backwards("hide_menu")
			open_sound.play()
			close_sound.stop()
		else:
			animation_player.play("hide_menu")
			close_sound.play()
			open_sound.stop()
	)

	animation_player.animation_finished.connect(func(_animation):
		if show_menu.value == false:
			App.main.remove_child(self)
	)

	EventSystem.on_action_down.connect(func(action):
		if action.name == "menu_button":
			toggle_open()
	)

	EventSystem.on_notify.connect(func(event: EventNotify):
		var notification_node=Notification.instantiate()
		notification_node.text=event.message
		notification_node.type=event.type

		for child in notify_place.get_children():
			child.position += Vector3(0, 0.06, 0)

		notify_place.add_child(notification_node)
	)

func toggle_open():
	show_menu.value = !show_menu.value

func move_into_view():
	var camera_transform = App.camera.global_transform
	camera_transform.origin -= camera_transform.basis.z * 0.5

	global_transform = camera_transform
