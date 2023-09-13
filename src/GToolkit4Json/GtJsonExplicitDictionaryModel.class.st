Class {
	#name : #GtJsonExplicitDictionaryModel,
	#superclass : #GtJsonDictionaryModel,
	#instVars : [
		'keys',
		'modelClass',
		'defaultValue'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> defaultValue [
	^ defaultValue
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> defaultValue: anObject [
	defaultValue := anObject
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> doesNotUnderstand: aMessage [
	| aSelector |
	aMessage numArgs isZero ifTrue: [ aSelector := aMessage selector ].

	aMessage numArgs = 1
		ifTrue: [ aSelector := aMessage selector copyFrom: 1 to: aMessage selector size - 1 ].

	(self keys includes: aSelector)
		ifFalse: [ self keys: (self keys copyWith: aSelector) ].

	^ super doesNotUnderstand: aMessage
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> jsonModelDefinition [
	^ keys
		collect: [ :key | 
			modelClass
				key: key
				at: self
				defaultValue: defaultValue ]
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> keys [
	^ keys
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> keys: anObject [
	keys := anObject
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> modelClass [
	^ modelClass
]

{ #category : #accessing }
GtJsonExplicitDictionaryModel >> modelClass: anObject [
	modelClass := anObject
]
