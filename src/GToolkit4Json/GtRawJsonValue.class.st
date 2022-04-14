Class {
	#name : #GtRawJsonValue,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instance creation' }
GtRawJsonValue class >> forValue: aJsonObject [

	^ self new value: aJsonObject
]

{ #category : #'instance creation' }
GtRawJsonValue class >> null [

	^ GtRawJsonMissingValue default
]

{ #category : #accessing }
GtRawJsonValue >> exists [

	^ true
]

{ #category : #accessing }
GtRawJsonValue >> value [

	^ value
]

{ #category : #accessing }
GtRawJsonValue >> value: anObject [

	value := anObject
]
