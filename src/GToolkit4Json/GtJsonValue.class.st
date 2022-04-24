Class {
	#name : #GtJsonValue,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'GToolkit4Json-Json - Value'
}

{ #category : #'instance creation' }
GtJsonValue class >> error: anError [

	^ GtJsonModelErrorValue new exception: anError
]

{ #category : #'instance creation' }
GtJsonValue class >> forValue: aJsonObject [

	^ self new value: aJsonObject
]

{ #category : #'instance creation' }
GtJsonValue class >> null [

	^ GtJsonMissingValue default
]

{ #category : #accessing }
GtJsonValue >> exists [

	^ true
]

{ #category : #accessing }
GtJsonValue >> value [

	^ value
]

{ #category : #accessing }
GtJsonValue >> value: anObject [

	value := anObject
]
