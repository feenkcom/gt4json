Class {
	#name : #GtJsonModel,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'GToolkit4Json-Users'
}

{ #category : #'instance creation' }
GtJsonModel class >> forJson: aGtJson [

	^ self new json: aGtJson
]

{ #category : #'instance creation' }
GtJsonModel class >> forJsonCollection: aCollection [

	^ aCollection collect: [ :eachJson | self forJson: eachJson ]
]

{ #category : #'instance creation' }
GtJsonModel class >> forJsonString: aString [

	| aJson |
	aJson := GtJson forJsonString: aString.
	^ self new json: aJson
]

{ #category : #testing }
GtJsonModel >> exists [

	^ self json isNotNil and: [ self json exists ]
]

{ #category : #'gt - extensions' }
GtJsonModel >> gtJsonObjectFor: aView context: aContext [

	<gtView>
	self exists ifFalse: [ ^ aView empty ].

	^ aView forward
		  title: 'JSON Object';
		  priority: 60;
		  object: [ self json ];
		  view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtJsonModel >> gtJsonPathFor: aView [

	<gtView>
	self json ifNil: [ ^ aView empty ].

	^ aView forward
		  title: 'JSON Path';
		  priority: 62;
		  object: [ self json ];
		  view: #gtJsonPathFor:
]

{ #category : #accessing }
GtJsonModel >> json [

	^ json
]

{ #category : #accessing }
GtJsonModel >> json: anObject [

	json := anObject
]
