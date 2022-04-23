Class {
	#name : #GtJsonModelMissingValue,
	#superclass : #Object,
	#instVars : [
		'defaultValue'
	],
	#category : #'GToolkit4Json-Users'
}

{ #category : #accessing }
GtJsonModelMissingValue >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonModelMissingValue >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #accessing }
GtJsonModelMissingValue >> description [

	^ 'The value is missing and a default value is used instead. The default value is `{1}`.' 
		  format: { self defaultValue }
]

{ #category : #testing }
GtJsonModelMissingValue >> exists [

	^ false
]

{ #category : #accessing }
GtJsonModelMissingValue >> value [

	^ self defaultValue
]
