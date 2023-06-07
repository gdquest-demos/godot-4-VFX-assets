extends Resource
class_name PreviewData

enum CATEGORIES {Effects, Backgrounds, Materials}
@export var title : String
@export var thumbnail : Texture
@export var preview_scene : PackedScene
@export var category = CATEGORIES.Effects
