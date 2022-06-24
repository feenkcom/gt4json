Class {
	#name : #GtJsonRasic,
	#superclass : #Object,
	#instVars : [
		'jsonValue'
	],
	#category : #'GToolkit4Json-Json'
}

{ #category : #converting }
GtJsonRasic >> asJson [

	^ self
]

{ #category : #converting }
GtJsonRasic >> asJsonString [

	^ String streamContents: [ :aStream | 
		  | aWriter |
		  aWriter := NeoJSONWriter on: aStream.
		  aWriter nextPut: self jsonObject ]
]

{ #category : #'accessing - path' }
GtJsonRasic >> at: anIndex [

	self exists ifFalse: [ ^ self atUnknown: anIndex ].

	self jsonObject isDictionary ifTrue: [ ^ self atKey: anIndex ].

	(self jsonObject isCollection and: [ self jsonObject isString not ])
		ifTrue: [ ^ self atIndex: anIndex ].

	^ self atUnknown: anIndex
]

{ #category : #modifying }
GtJsonRasic >> at: anIndex put: aValue [
	| anInstance |
	anInstance := self.
	self exists
		ifFalse: [ anInstance := self createJsonObject: anIndex.
			self
				assert: [ anInstance exists ]
				description: [ 'JSON value was not created: {1}' format: {anInstance} ] ].

	anInstance jsonObject isDictionary
		ifTrue: [ ^ anInstance atKey: anIndex put: aValue ].

	(anInstance jsonObject isCollection and: [ anInstance jsonObject isString not ])
		ifTrue: [ ^ anInstance atIndex: anIndex put: aValue ].

	self
		error: ('Cannot put {2} at {1} into a leaf object: {3}'
				format: {anIndex.
						aValue.
						anInstance})
]

{ #category : #'accessing - path' }
GtJsonRasic >> atIndex: anIndex [
	| aJsonObject |
	self
		assert: [ anIndex isInteger ]
		description: [ 'Index must be an integer number: {1}' format: {anIndex} ].

	aJsonObject := self jsonObject
			at: anIndex
			ifAbsent: [ ^ GtJsonIndex new
					parent: self;
					index: anIndex ].

	^ GtJsonIndex new
		parent: self;
		index: anIndex;
		jsonObject: aJsonObject
]

{ #category : #'accessing - path' }
GtJsonRasic >> atIndex: anIndex put: aValue [
	| aJsonObject |
	self
		assert: [ anIndex isInteger ]
		description: [ 'Index must be an integer: {1}' format: {anIndex} ].

	anIndex > self jsonObject size
		ifTrue: [ self increaseCollectionToSize: anIndex ].
	self jsonObject at: anIndex put: aValue.

	^ self atIndex: anIndex
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

{ #category : #modifying }
GtJsonRasic >> atKey: aKey put: aValue [
	self jsonObject at: aKey put: aValue.
	^ self atKey: aKey
]

{ #category : #'accessing - path' }
GtJsonRasic >> atPath: aCollection [

	^ aCollection
		  inject: self
		  into: [ :aJson :anIndex | aJson at: anIndex ]
]

{ #category : #'accessing - path' }
GtJsonRasic >> atPath: aCollection put: aValue [
	| aParent |
	aParent := aCollection allButLast
			inject: self
			into: [ :aJson :anIndex | aJson at: anIndex ].

	^ aParent at: aCollection last put: aValue
]

{ #category : #'accessing - path' }
GtJsonRasic >> atUnknown: anIndex [

	^ GtJsonUnknown new
		  parent: self;
		  path: anIndex
]

{ #category : #accessing }
GtJsonRasic >> collect: aBlock [

	^ self jsonObject species
		  new: self jsonObject size
		  streamContents: [ :aStream | 
			  self jsonObject isDictionary
				  ifTrue: [ 
					  self jsonObject keysDo: [ :aKey | 
						  | aJson aResult |
						  aJson := self at: aKey.
						  aResult := aBlock cull: aJson.
						  aStream nextPut: aResult ] ]
				  ifFalse: [ 
					  1 to: self jsonObject size do: [ :anIndex | 
						  | aJson aResult |
						  aJson := self at: anIndex.
						  aResult := aBlock cull: aJson.
						  aStream nextPut: aResult ] ] ]
]

{ #category : #private }
GtJsonRasic >> createJsonObject: aType [
	"Create an empty JSON object based on the type.
	If the type is an integer value, then we create en empty list.
	Otherwise we create a dictionary object.
	Return the same GtJsonBasic instance if it holds the empty JSON object.
	It a GtJsonBasic instance do not hold the empty JSON object, 
	return a new GtJsonBasic instance."
	<return: #GtJsonBasic>

	self subclassResponsibility
]

{ #category : #'reflective operations' }
GtJsonRasic >> doesNotUnderstand: message [

	"Overwritten so that 'self foo' becomes 'self at: #foo' except that self is returned"

	| key |
	key := message selector.
	key isUnary ifTrue: [ ^ self at: key ].
	^ super doesNotUnderstand: message
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

{ #category : #private }
GtJsonRasic >> increaseCollectionToSize: aSize [
	| aCollection aNewCollection myParent |
	aCollection := self jsonObject.

	self
		assert: [ aCollection isCollection
				and: [ aCollection isDictionary not and: [ aCollection isString not ] ] ]
		description: [ 'JSON object must be a collection: {1}' format: {aCollection} ].

	aNewCollection := aCollection species new: (aSize max: aCollection size).

	aCollection
		withIndexDo: [ :aValue :anIndex | aNewCollection at: anIndex put: aValue ].

	self jsonObject: aNewCollection.

	self updateValueInParent: aNewCollection
]

{ #category : #initialization }
GtJsonRasic >> initialize [

	super initialize.

	jsonValue := GtJsonValue null
]

{ #category : #accessing }
GtJsonRasic >> jsonObject [

	^ jsonValue exists
		  ifTrue: [ jsonValue value ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
GtJsonRasic >> jsonObject: aJsonObject [

	jsonValue := GtJsonValue forValue: aJsonObject
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

{ #category : #private }
GtJsonRasic >> updateValueInParent: aNewValue [
	"Subclasses may update new value in their parents"

	self subclassResponsibility
]

{ #category : #evaluating }
GtJsonRasic >> value [
	"Overwritten to make this accessor available as key"
	
	^ self at: #value
]

{ #category : #enumerating }
GtJsonRasic >> withParentsDo: aBlock [

	self subclassResponsibility
]
