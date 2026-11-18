Class {
	#name : #GtJsonUtility,
	#superclass : #Object,
	#category : #'GToolkit4Json-Utilities'
}

{ #category : #keys }
GtJsonUtility class >> key: aKey matches: anotherKey [
	"Answer whether two JSON keys denote the same key.
	Be forgiving on input: a Symbol and a String with the same characters match.
	Don't rely on Symbol = String here; that isn't true on every platform (e.g. GemStone)."

	aKey = anotherKey ifTrue: [ ^ true ].
	^ aKey isString
		and: [ anotherKey isString and: [ aKey sameContentAs: anotherKey ] ]
]

{ #category : #keys }
GtJsonUtility class >> keyIn: aDictionary matching: aKey ifFound: aFoundBlock ifNone: aNoneBlock [
	"Evaluate aFoundBlock with the existing key of aDictionary that matches aKey
	(see #key:matches:), or evaluate aNoneBlock if there is none.
	The key as given is tried first, then its String form, then (last resort) a scan,
	so a String finds a Symbol key without creating a Symbol."

	| aStringKey |
	(aDictionary includesKey: aKey) ifTrue: [ ^ aFoundBlock value: aKey ].
	aKey isString ifFalse: [ ^ aNoneBlock value ].

	aStringKey := self normalizedKey: aKey.
	(aStringKey ~~ aKey and: [ aDictionary includesKey: aStringKey ])
		ifTrue: [ ^ aFoundBlock value: aStringKey ].

	aDictionary
		keysDo: [ :eachKey | (self key: eachKey matches: aKey) ifTrue: [ ^ aFoundBlock value: eachKey ] ].

	^ aNoneBlock value
]

{ #category : #factory }
GtJsonUtility class >> newValueOfType: aType [
	aType isInteger ifTrue: [ ^ Array empty ].
	^ OrderedDictionary new
]

{ #category : #keys }
GtJsonUtility class >> normalizedKey: aKey [
	"Answer the key GtJson stores and generates for aKey.
	JSON keys are strings: a Symbol is converted to a String, anything else (other strings,
	collection indexes) is answered unchanged.
	Be strict on output: keys created by GtJson are always strings."

	^ aKey isSymbol ifTrue: [ aKey asString ] ifFalse: [ aKey ]
]
