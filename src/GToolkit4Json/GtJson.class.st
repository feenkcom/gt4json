Class {
	#name : #GtJson,
	#superclass : #GtJsonBasic,
	#category : #'GToolkit4Json-Json'
}

{ #category : #'instance creation' }
GtJson class >> forJsonObject: aJsonObject [

	^ self new jsonObject: aJsonObject
]

{ #category : #'instance creation' }
GtJson class >> forJsonString: aString [

	| aJsonObject |
	aJsonObject := (NeoJSONReader on: aString readStream)
		               mapClass: OrderedDictionary;
		               next.

	^ self forJsonObject: aJsonObject
]

{ #category : #private }
GtJson >> evaluateBlock: aBlock [
	aBlock
		cull: self jsonObject
		cull: nil
		cull: nil
		cull: self
]

{ #category : #'gt - extensions' }
GtJson >> gtJsonPathItemText [

	^ self pathText
]

{ #category : #accessing }
GtJson >> pathText [

	<return: #BlText>
	^ 'root' asRopedText foreground:
		  BrGlamorousColors disabledButtonTextColor
]

{ #category : #private }
GtJson >> updateValueInParent: aNewValue [
	"Since I do not have a parent, I do nothing."

	
]

{ #category : #enumerating }
GtJson >> withParentsDo: aBlock [

	aBlock cull: self
]
