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
