Class {
	#name : #GtJsonListItemModelDefinition,
	#superclass : #Object,
	#instVars : [
		'key',
		'object',
		'modelClass'
	],
	#category : #'GToolkit4Json-Model - Definition'
}

{ #category : #accessing }
GtJsonListItemModelDefinition >> jsonModelDefinition [

	^ self object jsonModelDefinition
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> key [

	^ key
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #accessing }
GtJsonListItemModelDefinition >> valueDo: aBlock [

	^ aBlock cull: self object cull: false
]
