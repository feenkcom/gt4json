Class {
	#name : #GtJsonModel,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instance creation' }
GtJsonModel class >> forJson: aJson [

	^ self new json: aJson
]

{ #category : #'instance creation' }
GtJsonModel class >> forJson: aJson defaultValue: aValue [

	^ self forJson: aJson
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

{ #category : #'instance creation - definition' }
GtJsonModel class >> key: aKey at: anObject defaultValue: aValue [

	^ GtJsonModelDefinition new
		  object: anObject;
		  modelClass: self;
		  key: aKey;
		  defaultValue: aValue
]

{ #category : #'instance creation - definition' }
GtJsonModel class >> list: anObject defaultValue: aValue [
	^ GtJsonCollectionModelDefinition new
		modelClass: self;
		object: anObject;
		defaultValue: aValue
]

{ #category : #'instance creation - definition' }
GtJsonModel class >> listKey: aKey at: anObject defaultValue: aValue [

	^ GtJsonCollectionAtKeyModelDefinition new
		  object: anObject;
		  modelClass: self;
		  key: aKey;
		  defaultValue: aValue
]

{ #category : #converting }
GtJsonModel >> asJsonString [
	^ self json asJsonString
]

{ #category : #'gt - extensions' }
GtJsonModel >> gtJsonObjectFor: aView context: aContext [

	<gtView>
	self jsonExists ifFalse: [ ^ aView empty ].

	^ aView forward
		  title: 'JSON Object';
		  priority: 71;
		  object: [ self json ];
		  view: #gtJsonObjectFor:context:
]

{ #category : #'gt - extensions' }
GtJsonModel >> gtJsonPathFor: aView [

	<gtView>
	self json ifNil: [ ^ aView empty ].

	^ aView forward
		  title: 'JSON Path';
		  priority: 72;
		  object: [ self json ];
		  view: #gtJsonPathFor:
]

{ #category : #'gt - extensions' }
GtJsonModel >> gtModelChildren [

	^ #(  )
]

{ #category : #accessing }
GtJsonModel >> json [

	^ json
]

{ #category : #accessing }
GtJsonModel >> json: anObject [

	json := anObject
]

{ #category : #testing }
GtJsonModel >> jsonExists [

	^ self json isNotNil and: [ self json exists ]
]

{ #category : #accessing }
GtJsonModel >> jsonModelDefinition [

	^ #(  )
]

{ #category : #accessing }
GtJsonModel >> jsonObject [
	^ self json jsonObject
]
