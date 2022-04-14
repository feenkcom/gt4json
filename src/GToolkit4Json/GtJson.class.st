Class {
	#name : #GtJson,
	#superclass : #GtJsonRasic,
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instance creation' }
GtJson class >> forJsonObject: aJsonObject [

	^ self new jsonObject: aJsonObject
]

{ #category : #accessing }
GtJson >> defaultJsonObject [

	^ nil
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

{ #category : #enumerating }
GtJson >> withParentsDo: aBlock [

	aBlock cull: self
]
