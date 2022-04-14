Class {
	#name : #GtJsonRasic,
	#superclass : #Object,
	#instVars : [
		'jsonValue'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'accessing - path' }
GtJsonRasic >> at: anIndex [

	self exists ifFalse: [ ^ self atUnknown: anIndex ].

	self jsonObject isDictionary ifTrue: [ ^ self atKey: anIndex ].

	(self jsonObject isCollection and: [ self jsonObject isString not ])
		ifTrue: [ ^ self atIndex: anIndex ].

	^ self atLeaf: anIndex
]

{ #category : #'accessing - path' }
GtJsonRasic >> atIndex: anIndex [

	| aJsonObject |
	aJsonObject := self jsonObject at: anIndex ifAbsent: [ 
		               ^ GtJsonIndex new
			                 parent: self;
			                 index: anIndex ].

	^ GtJsonIndex new
		  parent: self;
		  index: anIndex;
		  jsonObject: aJsonObject
]

{ #category : #'accessing - path' }
GtJsonRasic >> atKey: aKey [

	^ self jsonObject
		  at: aKey
		  ifPresent: [ :aValue | 
			  GtJsonKey new
				  parent: self;
				  key: aKey;
				  jsonObject: aValue ]
		  ifAbsent: [ 
			  GtJsonKey new
				  parent: self;
				  key: aKey ]
]

{ #category : #'as yet unclassified' }
GtJsonRasic >> atLeaf: anIndex [

	^ GtJsonUnknown new
		  parent: self;
		  path: anIndex
]

{ #category : #'accessing - path' }
GtJsonRasic >> atPath: aCollection [

	^ aCollection
		  inject: self
		  into: [ :aJson :anIndex | aJson at: anIndex ]
]

{ #category : #'accessing - path' }
GtJsonRasic >> atUnknown: anIndex [

	^ GtJsonUnknown new
		  parent: self;
		  path: anIndex
]

{ #category : #accessing }
GtJsonRasic >> defaultJsonObject [

	^ self subclassResponsibility
]

{ #category : #testing }
GtJsonRasic >> exists [

	"Return true if a value exists at the given path"

	^ jsonValue isNotNil and: [ jsonValue exists ]
]

{ #category : #accessing }
GtJsonRasic >> fullPathText [

	| aPath |
	aPath := '' asRopedText.
	self withParentsDo: [ :aNode | aPath append: aNode pathText ].

	^ aPath
]

{ #category : #'gt - extensions' }
GtJsonRasic >> gtConstructRawJsonFor: anItem treeNode: aNode jsonObject: aCollection [

	| aChild |
	aChild := self.

	aNode withParentsDo: [ :eachNode | 
		eachNode value == aCollection ifFalse: [ 
			eachNode key isInteger
				ifTrue: [ aChild := aChild atIndex: eachNode key ]
				ifFalse: [ aChild := aChild atKey: eachNode key ] ] ].

	^ aChild
]

{ #category : #'gt - extensions' }
GtJsonRasic >> gtJsonObjectFor: aView context: aContext [

	<gtView>
	self exists ifFalse: [ ^ aView empty ].

	aContext at: #gtTreeExpansionLevel put: 1.
	aContext at: #gtTreeSend put: [ :anItem :aNode :aCollection | 
		self
			gtConstructRawJsonFor: anItem
			treeNode: aNode
			jsonObject: aCollection ].

	^ aView forward
		  title: 'JSON Object';
		  priority: 40;
		  object: [ self jsonObject ];
		  view: #gtRawJsonFor:context:;
		  actionButtonIcon: BrGlamorousVectorIcons inspect
		  tooltip: 'Inspect JSON Object'
		  action: [ :aButton | aButton phlow spawnObject: self jsonObject ]
]

{ #category : #'gt - extensions' }
GtJsonRasic >> gtJsonPathFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'JSON Path';
		  priority: 42;
		  items: [ self parents ];
		  column: 'Icon' stencil: [ :aNode | 
			  aNode exists
				  ifTrue: [ 
					  (GtInspectorAcceptIconStencil new
						   radius: 8;
						   thickness: 2) asElement background:
						  BrGlamorousColors successBackgroundColor ]
				  ifFalse: [ 
					  (BrPlusIconStencil close
						   radius: 8;
						   thickness: 2) asElement background:
						  BrGlamorousColors errorBackgroundColor ] ]
		  width: 35;
		  column: 'Name' text: #gtJsonPathItemText;
		  column: 'Full Path' text: #fullPathText weight: 4
]

{ #category : #'gt - extensions' }
GtJsonRasic >> gtJsonPathItemText [

	^ self subclassResponsibility
]

{ #category : #initialization }
GtJsonRasic >> initialize [

	super initialize.

	jsonValue := GtRawJsonValue null
]

{ #category : #accessing }
GtJsonRasic >> jsonObject [

	^ jsonValue exists
		  ifTrue: [ jsonValue value ]
		  ifFalse: [ self defaultJsonObject ]
]

{ #category : #accessing }
GtJsonRasic >> jsonObject: aJsonObject [

	jsonValue := GtRawJsonValue forValue: aJsonObject
]

{ #category : #accessing }
GtJsonRasic >> parents [

	^ Array streamContents: [ :aStream | 
		  self withParentsDo: [ :eachNode | aStream nextPut: eachNode ] ]
]

{ #category : #accessing }
GtJsonRasic >> pathText [

	<return: #BlText>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtJsonRasic >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self fullPathText asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonRasic >> root [

	^ self withParentsDo: [ :aNode | ^ aNode ]
]

{ #category : #enumerating }
GtJsonRasic >> withParentsDo: aBlock [

	self subclassResponsibility
]
