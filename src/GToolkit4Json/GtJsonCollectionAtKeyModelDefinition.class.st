Class {
	#name : #GtJsonCollectionAtKeyModelDefinition,
	#superclass : #Object,
	#instVars : [
		'key',
		'modelClass',
		'defaultValue',
		'object'
	],
	#category : #'GToolkit4Json-Model - Definition'
}

{ #category : #'instace creation' }
GtJsonCollectionAtKeyModelDefinition >> createModelForJson: aJson [

	^ self modelClass forJsonCollection: aJson
]

{ #category : #'instace creation' }
GtJsonCollectionAtKeyModelDefinition >> createModelForValue: aCollection [

	^ aCollection collect: [ :eachValue | 
		  self modelClass
			  forValue: eachValue
			  defaultValue: self defaultValue ]
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #testing }
GtJsonCollectionAtKeyModelDefinition >> includesKey: aKey [
	^ self key = aKey
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> jsonModelDefinition [

	| aCollection |
	aCollection := self object modelAt: self key.

	^ aCollection withIndexCollect: [ :eachModel :anIndex | 
		  GtJsonCollectionItemModelDefinition new
			  object: eachModel;
			  modelClass: self modelClass;
			  key: anIndex ]
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #printing }
GtJsonCollectionAtKeyModelDefinition >> printOn: aStream [

	super printOn: aStream.

	self key ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self key asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonCollectionAtKeyModelDefinition >> valueDo: aBlock [

	| aCollection isDefaultValue |
	aCollection := self object modelAt: self key.
	isDefaultValue := aCollection == self defaultValue.
	^ aBlock cull: aCollection cull: isDefaultValue
]
