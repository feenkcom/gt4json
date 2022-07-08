Class {
	#name : #GtJsonUtility,
	#superclass : #Object,
	#category : #'GToolkit4Json-Utilities'
}

{ #category : #factory }
GtJsonUtility class >> newValueOfType: aType [
	aType isInteger ifTrue: [ ^ Array empty ].
	^ OrderedDictionary new
]
