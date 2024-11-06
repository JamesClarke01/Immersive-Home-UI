extends Node3D
class_name TabsContent3D

@export var tabs: Tabs3D

var children: Array = []

func _ready():
	children = get_children()

	for i in range(children.size()):
		var child = children[i]
		child.visible = true
		remove_child(child)

		R.effect(func(_arg):
			if tabs.selected.value == i:
				add_child(child)
			elif child.get_parent() == self:
				remove_child(child)
		)
