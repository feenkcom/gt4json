"
I am NeoJSONSubSchema, I am a NeoJSONSchema that is rooted in another schema
"
Class {
	#name : #NeoJSONSubSchema,
	#superclass : #NeoJSONSchema,
	#instVars : [
		'root'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSubSchema >> root [
	^ root
]

{ #category : #accessing }
NeoJSONSubSchema >> root: aNeoJSONSchema [
	root := aNeoJSONSchema
]
