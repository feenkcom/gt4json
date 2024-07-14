Class {
	#name : #GtJsonBasic,
	#superclass : #Object,
	#instVars : [
		'jsonValue'
	],
	#category : #'GToolkit4Json-Json'
}

{ #category : #enumerating }
GtJsonBasic >> allLeafValuesDepthFirstDo: aBlock [
	self
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aJson | 
			(aValue isCollection and: [ aValue isString not ])
				ifFalse: [ aBlock
						cull: aValue
						cull: aKey
						cull: aParent
						cull: aJson ] ]
]

{ #category : #enumerating }
GtJsonBasic >> allValuesDepthFirstDo: aBlock [
	self exists ifFalse: [ ^ self ].
	self jsonObject isString
		ifTrue: [ self evaluateBlock: aBlock.
			^ self ].
	self jsonObject isDictionary
		ifTrue: [ self jsonObject
				keysDo: [ :eachKey | (self at: eachKey) allValuesDepthFirstDo: aBlock ].
			self evaluateBlock: aBlock.
			^ self ].
	self jsonObject isCollection
		ifTrue: [ 1
				to: self jsonObject size
				do: [ :anIndex | (self at: anIndex) allValuesDepthFirstDo: aBlock ] ].
	self evaluateBlock: aBlock
]

{ #category : #converting }
GtJsonBasic >> asGtJson [

	^ self
]

{ #category : #converting }
GtJsonBasic >> asJson [
	self
		deprecated: 'Please use #asGtJson instead.'
		transformWith: '`@receiver asJson' -> '`@receiver asGtJson'.
		
	^ self asGtJson
]

{ #category : #converting }
GtJsonBasic >> asJsonString [

	^ String streamContents: [ :aStream | 
		  | aWriter |
		  aWriter := NeoJSONWriter on: aStream.
		  aWriter nextPut: self jsonObject ]
]

{ #category : #'accessing - path' }
GtJsonBasic >> at: anIndex [

	self exists ifFalse: [ ^ self atUnknown: anIndex ].

	self jsonObject isDictionary ifTrue: [ ^ self atKey: anIndex ].

	(self jsonObject isCollection and: [ self jsonObject isString not ])
		ifTrue: [ ^ self atIndex: anIndex ].

	^ self atUnknown: anIndex
]

{ #category : #'accessing - path' }
GtJsonBasic >> at: anIndex ifAbsent: absentBlock [
	^ self
		at: anIndex
		ifPresent: [ :aJson | aJson ]
		ifAbsent: absentBlock
]

{ #category : #'accessing - path' }
GtJsonBasic >> at: anIndex ifPresent: presentBlock ifAbsent: absentBlock [
	| aJson |
	aJson := self at: anIndex.
	^ aJson ifExists: presentBlock ifNotExists: absentBlock
]

{ #category : #modifying }
GtJsonBasic >> at: anIndex put: aValue [
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

{ #category : #'private - path' }
GtJsonBasic >> atIndex: anIndex [
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

{ #category : #'private - path' }
GtJsonBasic >> atIndex: anIndex put: aValue [
	| aJsonObject |
	self
		assert: [ anIndex isInteger ]
		description: [ 'Index must be an integer: {1}' format: {anIndex} ].

	anIndex > self jsonObject size
		ifTrue: [ self increaseCollectionToSize: anIndex ].
	self jsonObject at: anIndex put: aValue.

	^ self atIndex: anIndex
]

{ #category : #'private - path' }
GtJsonBasic >> atKey: aKey [

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

{ #category : #'private - path' }
GtJsonBasic >> atKey: aKey put: aValue [
	self jsonObject at: aKey put: aValue.
	^ self atKey: aKey
]

{ #category : #'accessing - path' }
GtJsonBasic >> atPath: aCollection [

	^ aCollection
		  inject: self
		  into: [ :aJson :anIndex | aJson at: anIndex ]
]

{ #category : #'accessing - path' }
GtJsonBasic >> atPath: aCollection ifPresent: presentBlock ifAbsent: absentBlock [
	| aJson |
	aJson := self atPath: aCollection.
	^ aJson ifExists: presentBlock ifNotExists: absentBlock
]

{ #category : #'accessing - path' }
GtJsonBasic >> atPath: aCollection put: aValue [
	| aParent |
	aParent := aCollection allButLast
			inject: self
			into: [ :aJson :anIndex | aJson at: anIndex ].

	^ aParent at: aCollection last put: aValue
]

{ #category : #'private - path' }
GtJsonBasic >> atUnknown: anIndex [

	^ GtJsonUnknown new
		  parent: self;
		  path: anIndex
]

{ #category : #enumerating }
GtJsonBasic >> collect: aBlock [
	self exists ifFalse: [ ^ #() ].

	^ self jsonObject species
		new: self jsonObject size
		streamContents: [ :aStream | 
			self jsonObject isDictionary
				ifTrue: [ self jsonObject
						keysDo: [ :aKey | 
							| aJson aResult |
							aJson := self at: aKey.
							aResult := aBlock cull: aJson cull: aKey.
							aStream nextPut: aResult ] ]
				ifFalse: [ 1
						to: self jsonObject size
						do: [ :anIndex | 
							| aJson aResult |
							aJson := self at: anIndex.
							aResult := aBlock cull: aJson cull: anIndex.
							aStream nextPut: aResult ] ] ]
]

{ #category : #private }
GtJsonBasic >> createJsonObject: aType [
	"Create an empty JSON object based on the type.
	If the type is an integer value, then we create en empty list.
	Otherwise we create a dictionary object.
	Return the same GtJsonBasic instance if it holds the empty JSON object.
	It a GtJsonBasic instance do not hold the empty JSON object, 
	return a new GtJsonBasic instance."
	<return: #GtJsonBasic>

	self subclassResponsibility
]

{ #category : #enumerating }
GtJsonBasic >> detect: aBlock ifFound: aFoundBlock ifNone: anExceptionBlock [
	self jsonObject isDictionary
		ifTrue: [ self jsonObject
				keysDo: [ :aKey | 
					| aJson |
					aJson := self at: aKey.
					(aBlock cull: aJson cull: aKey)
						ifTrue: [ ^ aFoundBlock cull: aJson cull: aKey ] ] ]
		ifFalse: [ 1
				to: self jsonObject size
				do: [ :anIndex | 
					| aJson |
					aJson := self at: anIndex.
					(aBlock cull: aJson cull: anIndex)
						ifTrue: [ ^ aFoundBlock cull: aJson cull: anIndex ] ] ].

	^ anExceptionBlock value
]

{ #category : #enumerating }
GtJsonBasic >> do: aBlock [
	self jsonObject isDictionary
		ifTrue: [ self jsonObject
				keysDo: [ :aKey | 
					| aJson |
					aJson := self at: aKey.
					aBlock cull: aJson cull: aKey ] ]
		ifFalse: [ 1
				to: self jsonObject size
				do: [ :anIndex | 
					| aJson |
					aJson := self at: anIndex.
					aBlock cull: aJson cull: anIndex ] ]
]

{ #category : #'reflective operations' }
GtJsonBasic >> doesNotUnderstand: message [

	"Overwritten so that 'self foo' becomes 'self at: #foo' except that self is returned"

	| key |
	key := message selector.
	key isUnary ifTrue: [ ^ self at: key ].
	^ super doesNotUnderstand: message
]

{ #category : #private }
GtJsonBasic >> evaluateBlock: aBlock [
	self subclassResponsibility
]

{ #category : #testing }
GtJsonBasic >> exists [
	"Return true if a value exists at the given path"

	^ jsonValue isNotNil and: [ jsonValue exists ]
]

{ #category : #accessing }
GtJsonBasic >> fullPathText [

	| aPath |
	aPath := '' asRopedText.
	self withParentsDo: [ :aNode | aPath append: aNode pathText ].

	^ aPath
]

{ #category : #'gt - extensions' }
GtJsonBasic >> gtConstructRawJsonFor: anItem treeNode: aNode jsonObject: aCollection [

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
GtJsonBasic >> gtJsonObjectFor: aView context: aContext [
	<gtView>
	self exists ifFalse: [ ^ aView empty ].

	aContext at: #gtTreeExpansionLevel ifAbsentPut: [ 1 ].
	aContext
		at: #gtTreeSend
		put: [ :anItem :aNode :aCollection | 
			self
				gtConstructRawJsonFor: anItem
				treeNode: aNode
				jsonObject: aCollection ].
	aContext
		at: #gtTreeValueStyler
		ifAbsentPut: [ [ :aNode | aNode value gtJsonValueDisplayText ] ].

	^ aView forward
		title: 'JSON object';
		priority: 40;
		object: [ self jsonObject ];
		view: #gtRawJsonFor:context:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect JSON Object'
			action: [ :aButton | aButton phlow spawnObject: self jsonObject ]
]

{ #category : #'gt - extensions' }
GtJsonBasic >> gtJsonPathFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'JSON path';
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
GtJsonBasic >> gtJsonPathItemText [

	^ self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtJsonBasic >> gtJsonStringFor: aView [
	<gtView>
	self exists ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'JSON string';
		priority: 41;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ JSONParser gtStyler ];
		text: [ STONJSON toStringPretty: self jsonObject ]
]

{ #category : #'gt - extensions' }
GtJsonBasic >> gtJsonValueDisplayText [
	^ self jsonObject gtJsonValueDisplayText
]

{ #category : #testing }
GtJsonBasic >> ifExists: presentBlock ifNotExists: absentBlock [
	^ self exists ifTrue: [ presentBlock cull: self ] ifFalse: absentBlock
]

{ #category : #private }
GtJsonBasic >> increaseCollectionToSize: aSize [
	| aCollection aNewCollection |
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
GtJsonBasic >> initialize [

	super initialize.

	jsonValue := GtJsonValue null
]

{ #category : #accessing }
GtJsonBasic >> jsonObject [

	^ jsonValue exists
		  ifTrue: [ jsonValue value ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
GtJsonBasic >> jsonObject: aJsonObject [

	jsonValue := GtJsonValue forValue: aJsonObject
]

{ #category : #accessing }
GtJsonBasic >> parents [

	^ Array streamContents: [ :aStream | 
		  self withParentsDo: [ :eachNode | aStream nextPut: eachNode ] ]
]

{ #category : #accessing }
GtJsonBasic >> pathText [

	<return: #BlText>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtJsonBasic >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self fullPathText asString;
		nextPut: $)
]

{ #category : #accessing }
GtJsonBasic >> root [

	^ self withParentsDo: [ :aNode | ^ aNode ]
]

{ #category : #enumerating }
GtJsonBasic >> select: aBlock [
	| aSelection |
	self exists ifFalse: [ ^ GtJson forJsonObject: #() ].

	aSelection := self jsonObject species
			streamContents: [ :aStream | 
				self jsonObject isDictionary
					ifTrue: [ self jsonObject
							keysDo: [ :aKey | 
								| aJson aResult |
								aJson := self at: aKey.
								aResult := aBlock cull: aJson cull: aKey.
								aResult ifTrue: [ aStream nextPut: aJson jsonObject ] ] ]
					ifFalse: [ 1
							to: self jsonObject size
							do: [ :anIndex | 
								| aJson aResult |
								aJson := self at: anIndex.
								aResult := aBlock cull: aJson cull: anIndex.
								aResult ifTrue: [ aStream nextPut: aJson jsonObject ] ] ] ].

	^ GtJsonFilter new
		parent: self;
		jsonObject: aSelection
]

{ #category : #private }
GtJsonBasic >> updateValueInParent: aNewValue [
	"Subclasses may update new value in their parents"

	self subclassResponsibility
]

{ #category : #evaluating }
GtJsonBasic >> value [
	"Overwritten to make this accessor available as key"
	
	^ self at: #value
]

{ #category : #enumerating }
GtJsonBasic >> withParentsDo: aBlock [

	self subclassResponsibility
]
