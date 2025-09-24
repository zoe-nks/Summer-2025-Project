class_name ItemData
extends Resource

enum Type {HEAD, CHEST, LEG, TAIL}

@export var type: Type
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
