Class {
	#name : #GtJsonCollectionItemModelDefinition,
	#superclass : #Object,
	#instVars : [
		'key',
		'object',
		'modelClass'
	],
	#category : #'GToolkit4Json-Model - Definition'
}

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> jsonModelDefinition [

	^ self object jsonModelDefinition
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #accessing }
GtJsonCollectionItemModelDefinition >> valueDo: aBlock [

	^ aBlock cull: self object cull: false
]
