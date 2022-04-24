Class {
	#name : #GtJsonListModelDefinition,
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
GtJsonListModelDefinition >> createModelForJson: aJson [

	^ self modelClass forJsonCollection: aJson
]

{ #category : #'instace creation' }
GtJsonListModelDefinition >> createModelForValue: aCollection [

	^ aCollection collect: [ :eachValue | 
		  self modelClass
			  forValue: eachValue
			  defaultValue: self defaultValue ]
]

{ #category : #accessing }
GtJsonListModelDefinition >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonListModelDefinition >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #accessing }
GtJsonListModelDefinition >> jsonModelDefinition [

	| aCollection |
	aCollection := self object modelAt: self key.

	^ aCollection withIndexCollect: [ :eachModel :anIndex | 
		  GtJsonListItemModelDefinition new
			  object: eachModel;
			  modelClass: self modelClass;
			  key: anIndex ]
]

{ #category : #accessing }
GtJsonListModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonListModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonListModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonListModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonListModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonListModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #printing }
GtJsonListModelDefinition >> printOn: aStream [

	super printOn: aStream.

	self key ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self key asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonListModelDefinition >> valueDo: aBlock [

	| aCollection isDefaultValue |
	aCollection := self object modelAt: self key.
	isDefaultValue := aCollection == self defaultValue.
	^ aBlock cull: aCollection cull: isDefaultValue
]
