Class {
	#name : #GtJsonDictionariesAtKeyModelDefinition,
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
GtJsonDictionariesAtKeyModelDefinition >> createDefaultModel [
	| aDictionary |
	aDictionary := GtJsonExplicitDictionaryModel new.
	aDictionary keys: #().
	aDictionary modelClass: self modelClass.
	aDictionary defaultValue: self defaultValue value.

	^ aDictionary
]

{ #category : #'instace creation' }
GtJsonDictionariesAtKeyModelDefinition >> createModelForJson: aJson [
	| aDictionary |
	aDictionary := GtJsonExplicitDictionaryModel new.
	aDictionary keys: aJson jsonObject keys.
	aDictionary modelClass: self modelClass.
	aDictionary defaultValue: self defaultValue value.
	aDictionary json: aJson.

	^ aDictionary
]

{ #category : #'instace creation' }
GtJsonDictionariesAtKeyModelDefinition >> createModelForValue: aCollection [

	^ aCollection collect: [ :eachValue | 
		  self modelClass
			  forValue: eachValue
			  defaultValue: self defaultItemValue ]
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #testing }
GtJsonDictionariesAtKeyModelDefinition >> includesKey: aKey [
	^ self key = aKey
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> jsonModelDefinition [
	| aDictionary |
	aDictionary := self object modelAt: self key.

	^ aDictionary jsonModelDefinition
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #printing }
GtJsonDictionariesAtKeyModelDefinition >> printOn: aStream [

	super printOn: aStream.

	self key ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self key asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonDictionariesAtKeyModelDefinition >> valueDo: aBlock [

	| aCollection isDefaultValue |
	aCollection := self object modelAt: self key.
	isDefaultValue := aCollection == self defaultValue.
	^ aBlock cull: aCollection cull: isDefaultValue
]
