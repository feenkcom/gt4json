Class {
	#name : #GtJsonModelDefinition,
	#superclass : #Object,
	#instVars : [
		'modelClass',
		'key',
		'defaultValue',
		'object'
	],
	#category : #'GToolkit4Json-Model - Definition'
}

{ #category : #'instace creation' }
GtJsonModelDefinition >> createDefaultModel [
	^ GtJsonLeafModel new value: self defaultValue value
]

{ #category : #'instace creation' }
GtJsonModelDefinition >> createModelForJson: aJson [

	^ self modelClass forJson: aJson defaultValue: self defaultValue
]

{ #category : #'instace creation' }
GtJsonModelDefinition >> createModelForValue: aValue [

	^ self modelClass forValue: aValue defaultValue: self defaultValue
]

{ #category : #accessing }
GtJsonModelDefinition >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonModelDefinition >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #testing }
GtJsonModelDefinition >> includesKey: aKey [
	^ self key = aKey
]

{ #category : #accessing }
GtJsonModelDefinition >> jsonModelDefinition [

	^ self object
		  ifNotNil: [ :aModel | 
		  	(aModel modelAt: self key) jsonModelDefinition ]
		  ifNil: [ #(  ) ]
]

{ #category : #accessing }
GtJsonModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #printing }
GtJsonModelDefinition >> printOn: aStream [

	super printOn: aStream.

	self key ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self key asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonModelDefinition >> valueDo: aBlock [

	| aModel isDefaultValue |
	aModel := self object modelAt: self key.
	isDefaultValue := aModel valueExists not.
	^ aBlock cull: aModel value cull: isDefaultValue
]
